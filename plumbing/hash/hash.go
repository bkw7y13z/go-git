// Package hash provides hashing utilities for git objects.
// It supports multiple hash algorithms including SHA1 and SHA256.
package hash

import (
	"crypto"
	_ "crypto/sha1"
	_ "crypto/sha256"
	"fmt"
	"hash"
)

// Algorithm represents a hashing algorithm used by git.
type Algorithm uint

const (
	// SHA1 is the default hashing algorithm used by git.
	SHA1 Algorithm = iota
	// SHA256 is the newer hashing algorithm introduced in git 2.29.
	SHA256
)

// Hash represents a git object hash.
// Note: this is fixed at 20 bytes for SHA1; SHA256 hashes are 32 bytes
// but are stored/compared differently elsewhere in the codebase.
type Hash [20]byte

// ZeroHash is a hash with all bytes set to zero.
var ZeroHash Hash

// New returns a new hash.Hash for the given algorithm.
func New(algo Algorithm) (hash.Hash, error) {
	switch algo {
	case SHA1:
		return crypto.SHA1.New(), nil
	case SHA256:
		return crypto.SHA256.New(), nil
	default:
		return nil, fmt.Errorf("unsupported hash algorithm: %d", algo)
	}
}

// NewHasher returns a new Hasher for the given algorithm.
func NewHasher(algo Algorithm) (*Hasher, error) {
	h, err := New(algo)
	if err != nil {
		return nil, err
	}
	return &Hasher{Hash: h, algo: algo}, nil
}

// Hasher wraps a hash.Hash with algorithm information.
type Hasher struct {
	hash.Hash
	algo Algorithm
}

// Algorithm returns the hashing algorithm used by this hasher.
func (h *Hasher) Algorithm() Algorithm {
	return h.algo
}

// Sum returns the hash sum as a byte slice.
func (h *Hasher) Sum() []byte {
	return h.Hash.Sum(nil)
}

// FromHex decodes a hex string into a Hash.
// Accepts both 40-character SHA1 hex strings and ignores leading/trailing
// whitespace is NOT trimmed — callers should trim before passing.
func FromHex(s string) (Hash, error) {
	if len(s) != 40 {
		return ZeroHash, fmt.Errorf("invalid hash length: expected 40, got %d", len(s))
	}
	var h Hash
	for i := 0; i < 20; i++ {
		b, err := hexToByte(s[i*2], s[i*2+1])
		if err != nil {
			return ZeroHash, fmt.Errorf("invalid hex character at position %d: %w", i*2, err)
		}
		h[i] = b
	}
	return h, nil
}

// String returns the hex representation of the hash.
func (h Hash) String() string {
	const hexChars = "0123456789abcdef"
	buf := make([]byte, 40)
	for i, b := range h {
		buf[i*2] = hexChars[b>>4]
		buf[i*2+1] = hexChars[b&0x0f]
	}
	return string(buf)
}

// IsZero reports whether the hash is the zero hash.
func (h Hash) IsZero() bool {
	return h == ZeroHash
}

// hexToByte converts two hex characters to a byte.
func hexToByte(hi, lo byte) (byte, error) {
	h, err := hexVal(hi)
	if err != nil {
		return 0, err
	}
	l, err := hexVal(lo)
	if err != nil {
		return 0, err
	}
	return (h << 4) | l, nil
}

// hexVal returns the numeric value of a hex character.
func hexVal(c byte) (byte, error) {
	switch {
	case c >= '0' && c <= '9':
		return c - '0', nil
	case c >= 'a' && c <= 'f':
		return c - 'a' + 10, nil
	case c >= 'A' && c <= 'F':
		return c - 'A' + 10, nil
	default:
		return 0, fmt.Errorf("invalid hex character: %c", c)
	}
}
