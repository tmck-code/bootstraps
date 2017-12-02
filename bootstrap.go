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
	installLinux  = flag.Bool("linux", false, "install base linux dependencies")
	installUbuntu = flag.Bool("ubuntu", false, "install base ubuntu dependencies")
	installOsx    = flag.Bool("osx", false, "install base OSX dependencies")
	installRuby   = flag.Bool("ruby", false, "install latest ruby")
	installPython = flag.Bool("python", false, "install latest python")
	installVim    = flag.Bool("vim", false, "install latest vim")
	taskTypes     = map[string]string{
		"linux":  "base",
		"osx":    "base",
		"ubuntu": "os",
		"ruby":   "lang",
		"python": "lang",
		"vim":    "tool",
	}
	installOrder   = []string{"base", "os", "lang", "tool"}
	installScripts = map[string]string{
		"linux":  "installers/linux.sh",
		"osx":    "installers/osx.sh",
		"ubuntu": "installers/ubuntu.sh",
		"ruby":   "installers/ruby.sh",
		"python": "installers/python.sh",
		"vim":    "installers/vim.sh",
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
