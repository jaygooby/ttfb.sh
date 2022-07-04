# Introduction

Measures [time-to-first-byte](https://en.wikipedia.org/wiki/Time_to_first_byte) for single or multiple URLs. Can show you quickest, slowest & median TTFB values plus optionally log all response headers.

![Sample run of ttfb.sh](https://github.com/jaygooby/ttfb.sh/raw/readme-assets/demo.gif)

```
Usage: ttfb [options] url [url...]
	-d debug
	-l <log file> (infers -d) log response headers. Defaults to ./curl.log
	-n <number> of times to test time to first byte
	-v verbose output. Show response breakdown (DNS lookup, TLS handshake etc)
```

Implicitly follows a redirection chain using curl's `-L` option.

Can log all response headers (the default log file is `./curl.log`) by calling with `-d`.

Override the default log file by specifying `-l /some/file`.

Get quickest, slowest and median TTFB values by specifying the number of times to call a URL; use `-n2` for 2 tests, `-n5` for 5 and so on.

Uses the calculation `%{time_starttransfer¹} - %{time_appconnect²}` which doesn't include any connection overhead, to better approximate [devtool’s TTFB figure](https://developers.google.com/web/tools/chrome-devtools/network/understanding-resource-timing#slow_time_to_first_byte).

¹ [`time_starttransfer`](https://github.com/curl/curl/blob/e431daf013ea04cb1a988a2009d820224ef5fb79/docs/cmdline-opts/write-out.d#L141-L144)
> The time, in seconds, it took from the start until the first byte was just about to be transferred. This includes time_pretransfer and also the time the server needed to calculate the result.</blockquote>

² [`time_appconnect`](https://github.com/curl/curl/blob/e431daf013ea04cb1a988a2009d820224ef5fb79/docs/cmdline-opts/write-out.d#L118-L120)
>The time, in seconds, it took from the start until the SSL/SSH/etc
connect/handshake to the remote host was completed.

# Genesis
Based on a [gist](https://gist.github.com/sandeepraju/1f5fbdbdd89551ba7925abe2645f92b5)
by https://github.com/sandeepraju

Modified by jay@gooby.org, [@jaygooby](https://twitter.com/jaygooby)

# Installation
Download the script from the master branch and make it executable:
```
curl -LJO https://raw.githubusercontent.com/jaygooby/ttfb.sh/master/ttfb
chmod +x ./ttfb
```

# Usage

```
Usage: ttfb [options] url [url...]
	-d debug
	-l <log file> (infers -d) log response headers. Defaults to ./curl.log
	-n <number> of times to test time to first byte
	-v verbose output. Show response breakdown (DNS lookup, TLS handshake etc)
```

## Examples

Basic usage:

```
$ ttfb example.com
.227436
```

Basic usage with verbose response breakdown:

```
$ ttfb -v https://example.com
DNS lookup: 0.005152 TLS handshake: 0.000000 TTFB including connection: 0.200831 TTFB: .200831 Total time: 0.201132
```

Test multiple times:

```
$ ttfb -n 5 example.com/example/url
.....
fastest .177263 slowest .214302 median .179957
```

Test multiple URLs:

```
$ ttfb bbc.co.uk news.bbc.co.uk
bbc.co.uk        .049985
news.bbc.co.uk   .054122
```

Test multiple URLs, multiple times:

```
$ ttfb -n 5 bbc.co.uk news.bbc.co.uk
.....
.....
bbc.co.uk       fastest .030936 slowest .057755 median .034663
news.bbc.co.uk  fastest .031413 slowest .182791 median .035001
```

Verbose response breakdown when multiple tests specified:

```
$ ttfb -v -n 5 bbc.co.uk
DNS lookup: 0.005335 TLS handshake: 0.102314 TTFB including connection: 0.148328 TTFB: .046014 Total time: 0.646115
DNS lookup: 0.005322 TLS handshake: 0.102609 TTFB including connection: 0.150693 TTFB: .048084 Total time: 0.644611
DNS lookup: 0.004277 TLS handshake: 0.102066 TTFB including connection: 0.172199 TTFB: .070133 Total time: 1.196256
DNS lookup: 0.004444 TLS handshake: 0.107375 TTFB including connection: 0.160771 TTFB: .053396 Total time: 0.637290
DNS lookup: 0.005352 TLS handshake: 0.118882 TTFB including connection: 0.168772 TTFB: .049890 Total time: 0.653761

fastest .046014 slowest .070133 median .049890
```

Log all the response headers for multiple tests to multiple URLs:

```
ttfb -d -n 2 bbc.co.uk https://www.bbc.co.uk/weather
..
..
bbc.co.uk                      fastest .027550 slowest .055215 median .041382
https://www.bbc.co.uk/weather  fastest .101020 slowest .297923 median .199471

$ ls *.log
bbc_co_uk-curl.log                     https___www_bbc_co_uk_weather-curl.log

$ cat https___www_bbc_co_uk_weather-curl.log
HTTP/2 200
server: openresty
x-cache-action: MISS
vary: Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Scheme,X-CDN
x-cache-age: 0
cache-control: private, stale-while-revalidate=10, max-age=0, must-revalidate
content-type: text/html;charset=utf-8
x-mrid: w1
date: Thu, 11 Apr 2019 17:08:07 GMT
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
x-lb-nocache: true
x-msig: 24e37f81323984e4e45b8048f9e3c94a
x-frame-options: SAMEORIGIN
content-length: 1077454

HTTP/2 200
server: openresty
x-cache-action: MISS
vary: Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Scheme,X-CDN
x-cache-age: 0
cache-control: private, stale-while-revalidate=10, max-age=0, must-revalidate
content-type: text/html;charset=utf-8
x-mrid: w1
date: Thu, 11 Apr 2019 17:08:08 GMT
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
x-lb-nocache: true
x-msig: 24e37f81323984e4e45b8048f9e3c94a
x-frame-options: SAMEORIGIN
content-length: 1077454
```

# More detail on time-to-first-byte

See https://blog.cloudflare.com/a-question-of-timing/
and https://curl.haxx.se/docs/manpage.html for an explanation
of how the curl variables relate to the various stages of
the transfer.

![Diagram showing what each of the curl variable timings refer to against a typical HTTP over TLS 1.2 connection](https://blog.cloudflare.com/content/images/2018/10/Screen-Shot-2018-10-16-at-14.51.29-1.png)

To get a better approximation of devtool's TTFB, we consider
the time without the connection overhead:
`%{time_starttransfer} - %{time_appconnect}`

Uses a dirty `eval` to do the ttfb arithmetic. Depends
on `bc` and `column` commands.

# TODO

  * [x] Show progress when more than one request (`-n 2` etc) option is set

  * [ ] Sort output by fastest TTFB when multiple URLs are supplied

  * [ ] Colour code the `TTFB:` figure in the standard response, according to the speed of the response.
