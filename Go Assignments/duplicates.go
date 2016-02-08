/*
Go Pex
by Bradley Trowbridge
Programming Languages
Spring 2016
*/

package main

import (
	"bufio"
	"crypto/sha1"
	"flag"
	"fmt"
	//"io/ioutil"
	"io"
	"os"
	"path/filepath"
	"runtime"
	"sync"
	"time"
)

var GoCount int
var fileCount int

//struct holding file stuff that we care about
type FileStuff struct {
	filepath   string
	hash       string
	count      uint
	duplicates []string
}

//processes the file and codes the data through the Sha-1 algorithm
func processFile(results chan<- FileStuff, filepath string) {

	hasher := sha1.New()

	//f, err := ioutil.ReadFile(filepath)
	infile, err := os.Open(filepath)
	if err != nil {
		fmt.Printf("Opening %v returned with an error of %v.\n", filepath, err.Error())
	} else {
		fileCount += 1
	}

	defer infile.Close()

	infile.WriteString(hasher)

	result := string(hasher.Sum(nil)[:20])

	//creates FileStuff object
	encodedFile := FileStuff{filepath, result, 1, nil}
	results <- encodedFile //pushes to thread safe channel

}

//scoping function to hold the recursive Walk() function
func findDuplicates(root string, results chan FileStuff) {
	fmt.Println("Finding Duplicates...")
	var yield sync.WaitGroup
	//Processes each file, starting new goroutines on larger files
	walkfn := func(path string, f os.FileInfo, err error) error {
		if !f.IsDir() {
			if f.Size() > 1024 {

				//fmt.Println("Go routine: ", count)
				GoCount += 1
				yield.Add(1)
				go func() {
					processFile(results, path)
					defer yield.Done()
				}()
			} else {
				processFile(results, path)
			}
		}
		return err

	}

	err := filepath.Walk(root, walkfn)
	if err != nil {
		fmt.Printf("filepath.Walk() returned %v\n", err.Error())
	}

	yield.Wait()
	close(results) //channel closes after Walk
}

//takes results on the channel and sorts them into unique and duplicate filemaps
//outputs map of duplicates and first instance
func mergeResults(results <-chan FileStuff) map[string]FileStuff {
	fmt.Println("Merging Results...")
	fileList := make(map[string]FileStuff) //uses hash to identify unique
	//loops until results is closed and empty
	for file := range results {
		if f, ok := fileList[file.hash]; ok {

			f.count += 1
			f.duplicates = append(f.duplicates, file.filepath) //add to duplicates list

		} else {

			fileList[file.hash] = file

		}
	}
	return fileList
}

func outputResults(fileList map[string]FileStuff) {
	fmt.Println("Results...")
	//outputs the name and count of duplicate files
	for _, file := range fileList {
		if file.count > 1 {
			fmt.Printf("Duplicates found of first instance %v with %v occurrences.\n", file.filepath, file.count)

			for dupePath := range file.duplicates {
				fmt.Printf("-----Duplicates  found in %v.\n", dupePath)
			}
		}
	}

}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU()) // Use all the machine's cores

	flag.Parse()
	root := flag.Arg(0)

	//main channel
	results := make(chan FileStuff)

	start := time.Now() //timer

	//finds duplicates
	go findDuplicates(root, results)

	//moves duplicates from merge to output
	fileList := mergeResults(results)
	outputResults(fileList)

	//calc time
	end := time.Now()
	timer := end.Sub(start)
	//analytics
	fmt.Println("Program Done!")
	fmt.Println("Go Routine Count: ", GoCount)
	fmt.Println("File Count: ", fileCount)
	fmt.Println("Timer: ", timer)

}
