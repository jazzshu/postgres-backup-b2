package main

import (
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"sync"
	"syscall"

	"github.com/robfig/cron/v3"
)

func execute(command string, args []string) {

	println("executing:", command, strings.Join(args, " "))

	cmd := exec.Command(command, args...)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		println(err.Error())
	}
}

func create(schedule string, command string, args []string) (cr *cron.Cron, wgr *sync.WaitGroup) {
	wg := &sync.WaitGroup{}

	parser := cron.NewParser(
		cron.SecondOptional | cron.Minute | cron.Hour | cron.Dom | cron.Month | cron.Dow | cron.Descriptor,
	)

	_, err := parser.Parse(schedule)
	if err != nil {
		println(err.Error())
		os.Exit(1)
	}

	c := cron.New(cron.WithParser(parser))
	println("new cron:", schedule)

	c.AddFunc(schedule, func() {
		wg.Add(1)
		execute(command, args)
		wg.Done()
	})

	return c, wg
}

func start(c *cron.Cron, wg *sync.WaitGroup) {
	c.Start()
}

func stop(c *cron.Cron, wg *sync.WaitGroup) {
	println("Stopping")
	c.Stop()
	println("Waiting")
	wg.Wait()
	println("Exiting")
	os.Exit(0)
}

func main() {
	if len(os.Args) < 3 {
		println("Usage: go-cron [schedule] [command] [args ...]")
		os.Exit(1)
	}

	var schedule string = os.Args[1]
	var command string = os.Args[2]
	var args []string = os.Args[3:len(os.Args)]

	c, wg := create(schedule, command, args)

	go start(c, wg)

	ch := make(chan os.Signal, 1)
	signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM)
	println(<-ch)

	stop(c, wg)
}
