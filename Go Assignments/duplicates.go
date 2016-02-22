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
	"sync"
	"time"
)

var GoCount int
var fileCount int

//struct holding file stuff that we care about
type FileStuff struct {
	filepath   string
	hash       [20]byte
	count      uint
	duplicates []FileStuff
}

func check(e error) {
	if e != nil {
		fmt.Printf("ERROR: ", e.Error())
		panic(e)
	}
}

//processes the file and codes the data through the Sha-1 algorithm
func processFile(results chan<- FileStuff, filepath string, info os.FileInfo) {

	hasher := sha1.New()
	hasher.Reset()

	file, err := os.Open(filepath)
	check(err)
	defer file.Close()

	data := make([]byte, info.Size())

	_, err = file.Read(data)
	check(err)

	hasher.Write(data)

	hash := hasher.Sum(nil)[:20]

	var result [20]byte

	for i := range hash {
		result[i] = hash[i]
	}

	//fmt.Printf("Filepath: %v  | Hash: %s  \n", filepath, result)
	//panic(nil)

	//creates FileStuff object
	encodedFile := FileStuff{filepath, result, 1, []FileStuff{}}
	results <- encodedFile //pushes to thread safe channel
	fileCount += 1
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
					processFile(results, path, f)
					defer yield.Done()
				}()
			} else {
				processFile(results, path, f)
			}
		}
		return err

	}

	err := filepath.Walk(root, walkfn)
	check(err)

	yield.Wait()
	close(results) //channel closes after Walk
}

//takes results on the channel and sorts them into unique and duplicate filemaps
//outputs map of duplicates and first instance
func mergeResults(results <-chan FileStuff) map[[20]byte]FileStuff {
	fmt.Println("Merging Results...")
	fileList := make(map[[20]byte]FileStuff) //uses hash to identify unique
	//loops until results is closed and empty
	for newFile := range results {
		if file, ok := fileList[newFile.hash]; ok {

			file.count++
			file.duplicates = append(file.duplicates, newFile) //add to duplicates list
			fileList[file.hash] = file

		} else {

			fileList[newFile.hash] = newFile

		}
	}
	return fileList
}

func outputResults(fileList map[[20]byte]FileStuff) {
	fmt.Println("Results...")
	//outputs the name and count of duplicate files
	for _, file := range fileList {
		if file.count > 1 {

			fmt.Printf("Duplicates found of first instance %v with %d occurrences\n", file.filepath, file.count)
			//fmt.Printf("Duplicates found of first instance %s with %d occurrences| hash value: %v\n", file.filepath, file.count, file.hash) //verbose

			for _, dupe := range file.duplicates {

				fmt.Printf("      %v\n", dupe.filepath)
				//fmt.Printf("      %s | Hash: %v\n", dupe.filepath, dupe.hash) //verbose

			}
		}
	}

}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU()) // Use all the machine's cores

	flag.Parse()
	root := flag.Arg(0)
	//root := "/cop4020/gecko-dev/"

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
	uniqueFiles := len(fileList)
	dupeFiles := fileCount - uniqueFiles
	fmt.Println("Program Done!")
	fmt.Println("Go Routine Count: ", GoCount)
	fmt.Println("File Count: ", fileCount)
	fmt.Println("Timer: ", timer)
	fmt.Println("Unique Files: ", uniqueFiles)
	fmt.Println("Duplicates: ", dupeFiles)

}
