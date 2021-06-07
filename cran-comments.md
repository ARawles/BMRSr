## Fix

This submission is in response to an email I received stating that the package should '...fail gracefully if the resource is not available or has changed...'.
The response is now checked for errors which are converted to R errors. There is also error handling around the request-sending process.
This is also a resubmission, fixing links the NEWS.md and README.md.

## Test environments
* local Windows 10 x64 install, R 4.0.3
* ubuntu 18.04.5 via GitHub Actions, (release), (devel), (oldrel)
* macOS-latest via GitHub Actions (release)
* windows-latest via GitHub Actions (release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Downstream dependencies

There are no downstream dependencies

