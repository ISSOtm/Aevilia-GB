package main

import (
	"flag"
	"image"
	"image/color"
	"log"
	"os"
	"sort"

	_ "golang.org/x/image/bmp"
)

var (
	in = flag.String("in", "", "input file to process")
)

type subImager interface {
	image.Image
	SubImage(r image.Rectangle) image.Image
}

func main() {
	flag.Parse()

	if *in == "" {
		log.Fatalf("You must specify an input image with -in")
	}

	f, err := os.Open(*in)
	if err != nil {
		log.Fatalf("Error opening %q: %v", *in, err)
	}
	defer f.Close()

	img, _, err := image.Decode(f)
	if err != nil {
		log.Fatalf("Error decoding image: %v", err)
	}

	w, h := img.Bounds().Dx(), img.Bounds().Dy()
	if w%8 != 0 || h%8 != 0 {
		log.Printf("Non-multiple-of-8 dimensions: %dx%d", w, h)
		return
	}

	si, ok := img.(subImager)
	if !ok {
		log.Fatalf("Decoded image doesn't support SubImage")
		return
	}

	ts := make(map[image.Image][]color.Color)
	for _, tile := range tiles(si) {
		cs := colors(tile)
		sort.Sort(byBrightness(cs))
		ts[tile] = cs
	}

	for tile, colors := range ts {
		if len(colors) == 1 {
			continue
		}
		log.Printf("%v -> %v", tile.Bounds(), colors)
	}
	for tile, colors := range ts {
		if len(colors) > 4 {
			log.Printf("Tile %v has more than 4 colors!", tile.Bounds())
		}
	}
}

func tiles(img subImager) []image.Image {
	var ts []image.Image
	for y := 0; y < img.Bounds().Dy()/8; y++ {
		for x := 0; x < img.Bounds().Dx()/8; x++ {
			ts = append(ts, img.SubImage(image.Rect(x*8, y*8, (x+1)*8, (y+1)*8)))
		}
	}
	return ts
}

func colors(img image.Image) []color.Color {
	cs := make(map[color.Color]bool)
	b := img.Bounds()
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			cs[img.At(x, y)] = true
		}
	}

	result := make([]color.Color, 0, len(cs))
	for c := range cs {
		result = append(result, c)
	}
	return result
}

type byBrightness []color.Color

func (b byBrightness) Len() int      { return len(b) }
func (b byBrightness) Swap(i, j int) { b[i], b[j] = b[j], b[i] }

func (b byBrightness) Less(i, j int) bool {
	r1, g1, b1, _ := b[i].RGBA()
	r2, g2, b2, _ := b[j].RGBA()
	return (r1 + g1 + b1) < (r2 + g2 + b2)
}
