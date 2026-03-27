package main

import (
	"log"
	"net/http"
	"os"
)

func main() {
	addr := ":8080"
	if p := os.Getenv("PORT"); p != "" {
		addr = ":" + p
	}
	http.HandleFunc("/", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusOK)
	})
	log.Fatal(http.ListenAndServe(addr, nil))
}
