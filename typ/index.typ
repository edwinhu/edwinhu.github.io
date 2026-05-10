#import "templates/website-head.typ": website-page
#import "lib.typ": sc, include-offset

#show: website-page

// Title as explicit h1 (not a Typst heading) — matches org export
#context {
  if target() == "html" {
    html.elem("h1", attrs: (class: "title"), smallcaps[Edwin Hu])
  } else {
    align(center, text(size: 2em, smallcaps[Edwin Hu]))
  }
}

#outline(depth: 2, title: "Table of Contents")

Associate Professor of Law\
#link("https://www.law.virginia.edu/hu")[University of Virginia School of Law]

#link("./cv")[CV (PDF)] | #link("https://papers.ssrn.com/sol3/cf_dev/AbsByAuth.cfm?per_id=1889790")[SSRN] | #link("https://www.linkedin.com/in/huedwin/")[LinkedIn] | #link("https://github.com/edwinhu")[GitHub]\
#link("./pin")[PIN Estimates] | #link("./sas")[SAS Macros] | #link("./software")[Software]

= Biography <interests>

#include "content/biography.typ"

= Research <research>

== #link("http://papers.ssrn.com/sol3/cf_dev/AbsByAuth.cfm?per_id=1889790")[Working Papers] <workingpapers>

#include-offset("content/workingpapers.typ", 3)

== #link("http://papers.ssrn.com/sol3/cf_dev/AbsByAuth.cfm?per_id=1889790")[Publications] <pubs>

#include-offset("content/publications.typ", 3)

== Book Chapters <bookchapters>

#include-offset("content/bookchapters.typ", 3)

= Selected Briefs and Petitions <briefs>

#include-offset("content/briefs.typ", 3)

= Selected Commentary <commentary>

#include-offset("content/commentary.typ", 3)

= Policy Work <policy>

#include "content/policy.typ"

= Contact <contact>

#include "content/contact.typ"
