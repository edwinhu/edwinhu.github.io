#import "lib.typ": sc, include-offset
#import "templates/cv-template.typ": cv-template

#show: cv-template

#include "content/contact.typ"

= Employment

#include-offset("content/experience.typ", 2)

= Education

#include-offset("content/education.typ", 2)

= Publications

#include-offset("content/publications.typ", 2)

= Book Chapters

#include-offset("content/bookchapters.typ", 2)

#v(0.5em)
= Working Papers

#include-offset("content/workingpapers.typ", 2)

= Selected Briefs and Petitions

#include-offset("content/briefs.typ", 2)

= Selected Commentary

#include-offset("content/commentary.typ", 2)

#v(0.5em)
= Academic Service

#include-offset("content/service.typ", 2)
