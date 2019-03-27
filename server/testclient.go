package main

import (
	"context"
	"fmt"

	prisma "./generated/prisma-client"
)

func main() {
	client := prisma.New(nil)
	ctx := context.TODO()

	//Create a new user
	// name := "kryounger@gmail.com"
	// newUser, err := client.CreateUser(prisma.UserCreateInput{
	// 	Email:     &name,
	// 	Firstname: "Kristofer",
	// 	Lastname:  "Younger",
	// }).Exec(ctx)
	// if err != nil {
	// 	panic(err)
	// }
	// fmt.Printf("Created new user: %+v\n", newUser)
	fmt.Println("start")
	users, err := client.Users(nil).Exec(ctx)
	if err != nil {
		panic(err)
	}
	for _, user := range users {
		fmt.Printf("Users\n%v\n", user)
	}

	notes, err := client.Notes(nil).Exec(ctx)
	if err != nil {
		panic(err)
	}
	for _, f := range notes {
		fmt.Printf(">>notes\n>> %v\n", f)
	}
	tags, err := client.Tags(nil).Exec(ctx)
	if err != nil {
		panic(err)
	}
	for _, f := range tags {
		fmt.Printf(">>tags\n>> %v\n", f)
	}
}
