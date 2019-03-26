Based on a gist https://gist.github.com/sandeepraju/5fbdbdd89551ba7925abe2645f92b5
by https://github.com/sandeepraju

Modified by jay@gooby.org, [@jaygooby](https://twitter.com/jaygooby)

```
Usage: ttfb [options] url [url...]
  -d debug
  -l <log file> (infers -d)
  -n number of times to test
```

Examples:

```
$ ttfb example.com
DNS lookup: 0.523402 TLS handshake: 0.000000 TTFB including connection: 692724 TTFB: .692724 Total time: 0.693508
```

```
$ ttfb -n 5 example.com
min .203970 max .181486 median .190033
```

```
$ ttfb -n 5 bbc.co.uk news.bbc.co.uk
bbc.co.uk       min .032791 max .039401 median .029214
news.bbc.co.uk  min .032927 max .032237 median .037458
```

```
$ ttfb bbc.co.uk news.bbc.co.uk
bbc.co.uk        DNS lookup: 0.005291 TLS handshake: 0.089403 TTFB including nnection: 0.119651 TTFB: .030248 Total time: 0.506010
news.bbc.co.uk   DNS lookup: 0.004266 TLS handshake: 0.077179 TTFB including nnection: 0.110649 TTFB: .033470 Total time: 0.598472
```

Implicitly follows redirects using curl's `-L`

Log all response headers (default log file is `curl.log`) by calling with `-d`

Override the default log file by specifying `-l /some/file`

Get min, max and median values by specifying the number of times to call
the URL (`-n2` etc)

If you specify more than one url and have specified `-d` or `-l` the log file
will be prefixed with the URL being requested.

```
$ ttfb -d bbc.co.uk news.bbc.co.uk
bbc.co.uk        DNS lookup: 0.005309 TLS handshake: 0.074216 TTFB including connection: 0.106453 TTFB: .032237 Total time: 0.462894
news.bbc.co.uk   DNS lookup: 0.005355 TLS handshake: 5.358041 TTFB including connection: 5.397377 TTFB: .039336 Total time: 6.013918

$ ls
bbc_co_uk-curl.log      news_bbc_co_uk-curl.log
```

See https://blog.cloudflare.com/a-question-of-timing/
and https://curl.haxx.se/docs/manpage.html for an explanation
of how the curl variables relate to the various stages of
the transfer.

![Diagram showing what each of the curl variable timings refer to against a typical HTTP over TLS 1.2 connection](https://blog.cloudflare.com/content/images/2018/10/Screen-Shot-2018-10-16-at-14.51.29-1.png)

To get a better approximation of devtool's TTFB, consider
the time without the connection overhead:
`%{time_starttransfer} - %{time_appconnect}`

Uses a dirty `eval` to do the ttfb arithmetic. Depends
on `bc` and `column` commands.
