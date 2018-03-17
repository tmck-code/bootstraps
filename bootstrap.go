package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"runtime"
)

var (
	installDebian   = flag.Bool("debian",   false, "install base debian dependencies")
	installDotfiles = flag.Bool("dotfiles", false, "deploy dotfiles from repo")
	installGolang   = flag.Bool("golang",   false, "install latest golang")
	installLinux    = flag.Bool("linux",    false, "install base linux dependencies")
	installOsx      = flag.Bool("osx",      false, "install base OSX dependencies")
	installPython   = flag.Bool("python",   false, "install latest python")
	installRuby     = flag.Bool("ruby",     false, "install latest ruby")
	installUbuntu   = flag.Bool("ubuntu",   false, "install base ubuntu dependencies")
	installVim      = flag.Bool("vim",      false, "install latest vim")
	installVimFull  = flag.Bool("vim_full", false, "install latest vim compiled from source")
	taskTypes       = map[string]string{
		"debian":   "os",
		"dotfiles": "config",
		"golang":   "lang",
		"linux":    "base",
		"osx":      "base",
		"python":   "lang",
		"ruby":     "lang",
		"ubuntu":   "os",
		"vim":      "tool",
		"vim_full": "tool",
	}
	installOrder   = []string{"base", "os", "lang", "tool", "config"}
	installScripts = map[string]string{
		"debian":   "installers/debian.sh",
		"dotfiles": "installers/dotfiles.sh",
		"golang":   "installers/golang.sh",
		"linux":    "installers/linux.sh",
		"osx":      "installers/osx.sh",
		"python":   "installers/python.sh",
		"ruby":     "installers/ruby.sh",
		"ubuntu":   "installers/ubuntu.sh",
		"vim":      "installers/vim.sh",
		"vim_full": "installers/vim_full.sh",
	}
	_, filePath, _, _ = runtime.Caller(0)
	dirPath           = filepath.Dir(filePath)
)

func main() {
	flag.Parse()
	var tasks []string
	visitor := func(a *flag.Flag) {
		if a.Value.String() == "true" {
			tasks = append(tasks, a.Name)
		}
	}
	flag.VisitAll(visitor)

	fmt.Printf("tasks to run %v\n", tasks)
	for i, stage := range installOrder {
		stageTasks := tasksForStage(tasks, stage)
		fmt.Printf("\ntasks for stage %d %-5s : %-s\n", i, stage, stageTasks)
		for _, task := range stageTasks {
			runTask(task)
		}
	}
}

func runTask(task string) {
	binary, err := binaryPath(path.Join(dirPath, installScripts[task]))
	if err != nil {
		fmt.Println("script for task does not exist:", task, installScripts[task], binary)
		log.Fatal(err)
	}

	fmt.Printf("\n- executing task %-10s -> %-s\n\n", task, binary)

	cmd := exec.Command(binary)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	execErr := cmd.Run()

	if execErr != nil {
		log.Fatal(err)
	}
	fmt.Println("finished executing task", task)
}

func tasksForStage(tasks []string, stage string) []string {
	var stageTasks []string
	for _, task := range tasks {
		if taskTypes[task] == stage {
			stageTasks = append(stageTasks, task)
		}
	}
	return stageTasks
}

func binaryPath(localPath string) (string, error) {
	if _, err := os.Stat(localPath); os.IsNotExist(err) {
		return "", err
	}
	return filepath.Abs(localPath)
}

