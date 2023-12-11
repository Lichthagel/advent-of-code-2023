package main

import (
	"os"
	"strings"
)

type Image struct {
	galaxies [][2]int
	dims     [2]int
}

func (img Image) IsGalaxy(x, y int) bool {
	for _, e := range img.galaxies {
		if e[0] == x && e[1] == y {
			return true
		}
	}
	return false
}

func (img Image) Print() {
	for x := 0; x < img.dims[0]; x++ {
		for y := 0; y < img.dims[1]; y++ {
			if img.IsGalaxy(x, y) {
				print("#")
			} else {
				print(".")
			}
		}
		println()
	}
	println()
}

func (img *Image) Grow(factor int) {
	// rows
out_rows:
	for x := 0; x < img.dims[0]; x++ {
		for _, e := range img.galaxies {
			if e[0] == x {
				continue out_rows
			}
		}

		for i, e := range img.galaxies {
			if e[0] > x {
				img.galaxies[i][0] = e[0] + (factor - 1)
			}
		}
		img.dims[0] += factor - 1
		x += factor - 1
	}

	// cols
out_cols:
	for y := 0; y < img.dims[1]; y++ {
		for _, e := range img.galaxies {
			if e[1] == y {
				continue out_cols
			}
		}

		for i, e := range img.galaxies {
			if e[1] > y {
				img.galaxies[i][1] = e[1] + (factor - 1)
			}
		}
		img.dims[1] += factor - 1
		y += factor - 1
	}
}

func AbsDiff(a, b int) int {
	if a > b {
		return a - b
	}
	return b - a
}

func (img Image) SumDistances() int {

	sum := 0

	for i := 0; i < len(img.galaxies); i++ {
		for j := i + 1; j < len(img.galaxies); j++ {
			dist := AbsDiff(img.galaxies[i][0], img.galaxies[j][0]) + AbsDiff(img.galaxies[i][1], img.galaxies[j][1])

			sum += dist
		}
	}

	return sum
}

func main() {
	if len(os.Args) < 2 {
		println("Please specify an input file")
		os.Exit(1)
	}

	input_bytes, err := os.ReadFile(os.Args[1])

	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(input_bytes), "\n")

	galaxies := [][2]int{}
	dims := [2]int{len(lines), len(lines[0])} // maybe handle newline? (not rly necessary since just an empty line with no galaxies)

	for x, line := range lines {
		for y, char := range line {
			if char == '#' {
				galaxies = append(galaxies, [2]int{x, y})
			}
		}
	}

	image := Image{galaxies, dims}

	image.Grow(2)
	println(image.SumDistances())

	image.Grow(500000)
	println(image.SumDistances())
}
