/*
Go Pex
by Bradley Trowbridge
Programming Languages
Spring 2016
*/

package main

import (
	"crypto/sha1"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
)

type FileStuff struct {
	name  string
	hash  [20]byte
	count uint
}

func processFile(results chan<- FileStuff, file os.FileInfo) {

	coder := sha1.New()
	coder.Write([]byte(file.Sys().([]byte)))
	result := sha1.Sum(file.Sys().([]byte))

	encodedFile := FileStuff{file.Name(), result, 1}
	results <- encodedFile
}

func findDuplicates(root string, results chan<- FileStuff) error {

	walkfn := func(path string, f os.FileInfo, err error) error {
		if f.Size() > 1024 {
			print("New Process")
			go processFile(results, f)

		} else {
			processFile(results, f)
		}
		return err
	}

	go func() {
		err := filepath.Walk(root, walkfn)
		fmt.Printf("filepath.Walk() returned %v\n", err)
	}()
	close(results)
	return nil
}

func mergeResults(results <-chan FileStuff) map[string]FileStuff {
	uniqueFiles := make(map[[20]byte]FileStuff)
	duplicates := make(map[string]FileStuff)

	for file := range results {
		if _, ok := uniqueFiles[file.hash]; ok {
			if temp, ok := duplicates[file.name]; ok {
				temp.count += 1
			} else {
				file.count = 2
				duplicates[file.name] = file
			}
		} else {
			uniqueFiles[file.hash] = file
		}
	}
	return duplicates
}

func outputResults(duplicates map[string]FileStuff) {

	for _, v := range duplicates {
		fmt.Printf("Match found in %v with %v occurrences.", v.name, v.count)
	}
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU()) // Use all the machine's cores
	flag.Parse()
	root := flag.Arg(0)
	results := make(chan FileStuff)

	findDuplicates(root, results)

	go func() {
		duplicates := mergeResults(results)
		defer outputResults(duplicates)
	}()

}
