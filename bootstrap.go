package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"syscall"
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

	env := os.Environ()

	fmt.Printf("tasks to run %v\n", tasks)
	for i, stage := range installOrder {
		stageTasks := tasksForStage(tasks, stage)
		fmt.Printf("\ntasks for stage %d %-5s : %-s\n", i, stage, stageTasks)
		for _, task := range stageTasks {
			runTask(task, []string{}, env)
		}
	}
}

func runTask(task string, args []string, env []string) {
	binary, err := binaryPath(installScripts[task])
	if err != nil {
		fmt.Println("script for task does not exist:", task, installScripts[task], binary)
		panic(err)
	}
	fmt.Printf("\n- executing task %-10s -> %-s\n\n", task, binary)
	execErr := syscall.Exec(binary, args, env)
	if execErr != nil {
		panic(execErr)
	}
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
