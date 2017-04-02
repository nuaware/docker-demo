package main

import (
	"flag"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"strings"
	"io/ioutil"
)

const (
        DOCKER_ASCII_ART = "static/img/docker_blue.txt"
	escape = "\x1b"
	colour_me_yellow = escape + "[1;33m"
	colour_me_normal = escape + "[0;0m"
)

var (
	mux        = http.NewServeMux()
	listenAddr string
)

type (
	Content struct {
		Title    string
		Hostname string
	}
)

func init() {
	flag.StringVar(&listenAddr, "listen", ":8080", "listen address")
}

func loadTemplate(filename string) (*template.Template, error) {
	return template.ParseFiles(filename)
}

func CaseInsensitiveContains(s, substr string) bool {
        s, substr = strings.ToUpper(s), strings.ToUpper(substr)
        return strings.Contains(s, substr)
}

func index(w http.ResponseWriter, r *http.Request) {
	log.Printf("request from %s\n", r.Header.Get("X-Forwarded-For"))

	hostname, err := os.Hostname()
	if err != nil {
		hostname = "unknown"
	}

	// Get user-agent: if wget/curl return ascii-text
	userAgent := r.Header.Get("User-Agent")

        if CaseInsensitiveContains(userAgent, "wget") || CaseInsensitiveContains(userAgent, "curl") {
           w.Header().Set("Content-Type", "text/txt")

	   content, _ := ioutil.ReadFile( DOCKER_ASCII_ART )
	   w.Write([]byte(content))
           fmt.Fprintf(w, "\n%sServed from host %s%s\n", colour_me_yellow, hostname, colour_me_normal)

	   return
	}

	// Get user-agent: else return html as normal ...
	t, err := loadTemplate("templates/index.html.tmpl")
	if err != nil {
		fmt.Printf("error loading template: %s\n", err)
		return
	}

	title := os.Getenv("TITLE")

	cnt := &Content{
		Title:    title,
		Hostname: hostname,
	}

	t.Execute(w, cnt)
}

func ping(w http.ResponseWriter, r *http.Request) {
	resp := fmt.Sprintf("ehazlett/docker-demo: hello %s\n", r.RemoteAddr)
	w.Write([]byte(resp))
}

func main() {
	flag.Parse()

	mux.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("./static"))))
	mux.HandleFunc("/ping", ping)
	mux.HandleFunc("/", index)

	log.Printf("listening on %s\n", listenAddr)

	if err := http.ListenAndServe(listenAddr, mux); err != nil {
		log.Fatalf("error serving: %s", err)
	}
}
