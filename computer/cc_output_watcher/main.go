package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"

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
				if event.Name == "inputs.json" && event.Op&fsnotify.Write == fsnotify.Write {
					// inputs.json was modified, reload the watched files
					log.Println("inputs.json changed, reloading config...")
					for _, file := range loadWatchedFilesConfig() {
						err = watcher.Add(file)
						if err == nil {
							log.Println("Added/Updated watch for:", file)
						}
					}
				} else if event.Op&fsnotify.Write == fsnotify.Write {
					// handle other file changes
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
	// Add inputs.json to watcher
	err = watcher.Add("inputs.json")
	if err == nil {
		log.Println("Watching inputs.json for changes")
	}
	// Add initial files from config
	for _, file := range loadWatchedFilesConfig() {
		err = watcher.Add(file)
		if err == nil {
			log.Println("Added initial watch for:", file)
		}
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
