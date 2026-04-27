module github.com/go-git/go-git/v5

go 1.21

require (
	dagger.io/dagger v0.9.3
	github.com/ProtonMail/go-crypto v0.0.0-20230923063757-afb1ddc0824c
	github.com/acomagu/bufpipe v1.0.4
	github.com/armon/go-socks5 v0.0.0-20160902184237-e75332964ef5
	github.com/emirpasic/gods v1.18.1
	github.com/gliderlabs/ssh v0.3.5
	github.com/go-git/gcfg v1.5.1-0.20230307220236-3a3c6141e376
	github.com/go-git/go-billy/v5 v5.5.0
	github.com/go-git/go-git-fixtures/v4 v4.3.2-0.20231010084843-55a94097c399
	github.com/golang/groupcache v0.0.0-20210331224755-41bb18bfe9da
	github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99
	github.com/kevinburke/ssh_config v1.2.0
	github.com/pjbgf/sha1cd v0.3.0
	github.com/sergi/go-diff v1.3.1
	github.com/skeema/knownhosts v1.2.1
	github.com/xanzy/ssh-agent v0.3.3
	golang.org/x/crypto v0.17.0
	golang.org/x/net v0.19.0
	golang.org/x/text v0.14.0
	gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c
)

require (
	github.com/cloudflare/circl v1.3.3 // indirect
	github.com/cyphar/filepath-securejoin v0.2.4 // indirect
	github.com/kr/pretty v0.3.1 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/rogpeppe/go-internal v1.11.0 // indirect
	golang.org/x/sys v0.16.0 // indirect
	gopkg.in/warnings.v0 v0.1.2 // indirect
)

// Personal fork - tracking upstream go-git/go-git for learning purposes.
// Upstream: https://github.com/go-git/go-git
//
// Notes:
//   - golang.org/x/crypto and golang.org/x/net pinned to specific versions to
//     avoid a breaking change introduced in newer releases (observed locally).
//   - dagger.io/dagger is only used in CI scripts; not needed for library consumers.
//   - TODO: investigate replacing github.com/acomagu/bufpipe with the stdlib
//     io.Pipe equivalent once I better understand where it's used in the
//     fetch/push code paths.
//   - TODO: github.com/armon/go-socks5 appears to be unmaintained (last commit
//     2016); worth checking if golang.org/x/net/proxy covers the same use case
//     before the next dependency audit.
//   - TODO: look into whether dagger.io/dagger can be moved to a separate
//     go.mod under _ci/ or similar to keep it out of the main module graph
//     entirely; it pulls in a large transitive closure that's irrelevant to
//     library consumers.
//   - NOTE: checked github.com/acomagu/bufpipe source on 2024-01-15; it wraps
//     a simple ring buffer + io.Pipe-like interface. stdlib io.Pipe should be
//     a drop-in for the fetch path once I trace through plumbing/protocol.
//   - NOTE: golang.org/x/sys pinned at v0.16.0 to match crypto/net versions;
//     bumping any of the three independently tends to cause 'ambiguous import'
//     errors in the test suite on my machine (macOS 14, go1.21.5).
//   - NOTE: verified on 2024-02-10 that github.com/sergi/go-diff v1.3.1 has a
//     known performance regression on large diffs (>10k lines); acceptable for
//     my use case but worth revisiting if I start using this on bigger repos.
//   - NOTE: checked on 2024-03-05 that golang.org/x/text v0.14.0 is safe from
//     CVE-2022-32149 (fixed in v0.3.8); we're well past that, no action needed.
