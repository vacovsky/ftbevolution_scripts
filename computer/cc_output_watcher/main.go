package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"time"

	"github.com/fsnotify/fsnotify"
)

func main() {

	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatal("NewWatcher failed: ", err)
	}
	defer watcher.Close()

	done := make(chan bool)
	go func() {
		defer close(done)

		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				// file change detected
				log.Printf("%s %s\n", event.Name, event.Op)
				// read in file to JSON
				if event.Op == fsnotify.Write {
					ingestMonitorDataToRedis(event.Name)
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				log.Println("error:", err)
			}
		}
	}()

	// for _, file := range loadMonitoredFilePaths() {
	// 	err = watcher.Add(file)
	// }

	go func() {
		for _, file := range loadWatchedFilesConfig() {
			err = watcher.Add(file)
			if err == nil {
				log.Println("Added new watched file:", file)
			}
		}
		time.Sleep(time.Second * 30)
	}()

	if err != nil {
		log.Fatal("Add failed:", err)
	}
	<-done
}

func loadWatchedFilesConfig() []string {
	files, err := ioutil.ReadFile("inputs.json")
	if err != nil {
		fmt.Println("Error reading file:", err)
	}

	// Unmarshal the JSON data into a slice of strings
	var filePaths []string
	err = json.Unmarshal(files, &filePaths)
	if err != nil {
		fmt.Println("Error unmarshalling JSON:", err)
	}
	for _, path := range filePaths {
		fmt.Println(path)
	}
	return filePaths
}
