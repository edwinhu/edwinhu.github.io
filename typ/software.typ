#import "templates/website-head.typ": website-page

#show: website-page.with(title: "Software", base: "..")

#context {
  if target() == "html" {
    html.elem("h1", attrs: (class: "title"), smallcaps[Software])
  } else {
    align(center, text(size: 2em, smallcaps[Software]))
  }
}

For a complete list of tools I use, you can browse my #link("https://github.com/edwinhu/nix")[nix configuration]. Warning: Nix has a steep learning curve, but the repository may give you ideas for other useful tools not mentioned here.

= Some command line tools worth learning

== #link("https://prefix.dev/docs/pixi/")[`pixi`]

I recommend #link("https://prefix.dev/docs/pixi/")[`pixi`], a modern, fast environment and package manager for the Python ecosystem, in the place of `anaconda` and `conda`. `pixi` is cross-platform, supports both Python and R, resolves environments quickly, and uses the familiar `conda-forge` ecosystem for package sourcing. It also manages all dependencies---including binaries and libraries---making installation and environment reproduction seamless.

Older tools like `anaconda` and `conda` are still widely used, but `pixi` has a much smoother workflow and improved speed. Instead of heavy base installs (`anaconda`), you define lightweight, reproducible environments in a `pixi.toml` file. This ensures all your dependencies are explicit and portable.

A minimal example for a Python data analysis environment:

```toml
[project]
name = "myenv"

[dependencies]
python = "3.11"
jupyter = "*"
pandas = "*"
numpy = "*"
scipy = "*"
scikit-learn = "*"
```

You can also run program without installing them:
```sh
pixi run jupyter-console
```

Another neat trick is that you can use `pixi-pack` to build an environment on one machine and deploy it to another machine. That means no need for more complicated tools like `docker`.

=== #link("https://github.com/astral-sh/uv")[`uv`]

Where you might have used `pip` for Python package management, I now recommend #link("https://github.com/astral-sh/uv")[`uv`]. `uv` is a fast drop-in replacement for `pip`. It performs lightning-fast installs, resolves dependencies robustly, and is compatible with both `requirements.txt` and `pyproject.toml` workflows.

Like `pixi`, `uv` works by adding packages to your virtual environment, and can also run a tool without installing using `uvx`.

=== `conda` for `R`

Yes I know, this is blasphemy. However, sometimes just getting a basic `R` installation up and running can take some time, as you might run into issues getting things to compile correctly on your system. In fact, getting `R` set up on different machines is what drove me to switch to python and to try `anaconda` in the first place. `anaconda` has actually #link("https://docs.anaconda.com/anaconda/user-guide/tasks/using-r-language/")[supported `R`] for years now, and just like with python it is an easy way to get started. Plus, with projects like #link("https://irkernel.github.io/")[`IRkernel`], which allows you to run `R` kernels in `jupyter notebook` it is a pretty good way to do interactive data analysis. Most `R` packages can be installed via `conda` with `r-[package name]`.

Much like `anaconda` for python, I recommend that new `R` users start with `tidyverse`, and `data.table` for getting started with data analysis:
```sh
conda install r-base r-essentials r-irkernel r-tidyverse r-data.table
```

If, like me, you find yourself constantly playing with different `R` packages then you may actually want to rely on `R`'s built-in `install.packages()`, or the `devtools::install_github` included in `tidyverse`. This may seem counterintuitive, as I have (hopefully) just convinced you that `pixi` is the best tool for package management in every context--but just as you may want to fall back on `pip` for python, you may find it easier to just use the default package manager in `R` _after_ you do your initial `pixi install`.

== #link("https://curl.haxx.se/")[`curl`]

These days much of the data you will want to analyze lives on the web. If you want to get this data you will run into terms like HTTP, FTP, REST APIs, JSON. If you want to work with these things you should probably learn `curl`.

The basic usage of `curl` is simple, yet endlessly customizable:
```sh
curl [options] [URL...]
```

Why `curl` over something like `wget`? `curl` by default writes to `STDOUT`, while `wget` writes directly to disk. This gives `curl` a significant advantage in being a flexible utility in between pipes.

Bonus tip: #link("https://anaconda.org/conda-forge/curl")[`curl` is available in `conda-forge`].

== #link("https://stedolan.github.io/jq/")[`jq`]

`jq` is like `awk` but specifically for json files. It is fast, flexible, and plays nicely with your other command-line tools.

It is extremely useful for pretty-printing your json files, and can be easily used to glob multiple files. The more advanced syntax including `select/map` can help you explore very complex files in just a few lines of code.

Bonus tip: #link("https://anaconda.org/conda-forge/jq")[`jq` is available in `conda-forge`].

== #link("http://xmlstar.sourceforge.net/overview.php")[`xmlstarlet`]

`xmlstarlet` is like `awk/sed/grep` for XML files.

It is extremely useful for browsing the structure of your XML files (`xmlstarlet el`), and subsequently extract the relevant information (`xmlstarlet sel`). It is written in `C` so it is very fast.

== #link("https://github.com/amethysts/xan")[`xan`]

Oftentimes you need to look through a csv file through the command line, and maybe you even want to do some basic analysis. Enter `xan`, which is written in Rust and is extremely fast and capable. `xan` can quickly filter, join, pretty print, etc. a csv, which makes it an invaluable tool.

I used to recommend `csvkit` which is written in python, but the performance of `xan` has convinced me to switch for good.

== #link("https://rclone.org/")[`Rclone`]

Rclone is a command-line tool for accessing data located in cloud storage, including common enterprise tools like Box, Dropbox, or Google Drive.

It's fairly easy to use because it has commands that should be familiar to most unix users. Moreover, it is pretty fast.

It also happens to be installed by default on WRDS (/usr/bin/rclone).

== #link("https://www.gnu.org/software/parallel/")[`GNU parallel`]

`GNU parallel` is a great command line utility written in Perl which allows for very fine-tuned control over parallelization. If you are familiar with something like `xargs`, then `parallel` is like a more robust, scalable version of `xargs`.

Admittedly the learning curve for `parallel` can be a bit high, but it makes replacing serial loops with parallel tasks very easy.

Suppose you have a script `SOMETHING` which you want to run over a list of `csv` files in your current directory:
```sh
for i in $(find *.csv); do
    ./SOMETHING $i
done
```

One way to easily parallelize this in `bash` is to add `&`:
```sh
for i in $(find *.csv); do
    ./SOMETHING $i &
done
```

You could also accomplish the same task with a pipe:
```sh
find *.csv | ./SOMETHING
```
or if the number of `csv` files is large you can use `xargs`:
```sh
find *.csv | xargs ./SOMETHING
```

If you want more fine tuned control, such as over the number of concurrent jobs, then that is where `parallel` comes in:
```sh
find *.csv | parallel -j8 ./SOMETHING
```

`parallel` is very powerful, and can handle things like parsing arguments, and handle concurrent writing in a safe way. Suppose that your input is a pipe delimited file that you want to pass as arugments to your script and output to a single file:
```sh
cat INPUT.csv | parallel --colsep '\|' "./SOMETHING {1} {2}" > OUTPUT.csv
```

Just remember you `bash` quoting rules and you will be fine!

== Other great CLI tools

- #link("https://github.com/sharkdp/bat")[`bat`] which is like `cat` with syntax highlighting, making it perfect for quickly viewing code and data files.
- #link("https://github.com/sharkdp/fd")[`fd`] which is a simple, fast alternative to `find` with intuitive syntax like `fd pattern` instead of `find . -name '*pattern*'`.
- #link("https://github.com/junegunn/fzf")[`fzf`] for fuzzy finding stuff.
- #link("https://github.com/ogham/exa")[`exa`] which is like a more advanced `ls`.
- #link("https://github.com/aristocratos/btop")[`btop`] which is a prettier `htop`.
- #link("https://github.com/BurntSushi/ripgrep")[`ripgrep`] which is a very fast `grep` search from the developer of `xsv`.
- #link("https://github.com/sxyazi/yazi")[`yazi`] which is a fast file manager.
- #link("https://github.com/ajeetdsouza/zoxide")[`zoxide`] which is a more advanced `cd`.
- #link("https://github.com/bensadeh/tailspin")[`tspin`] which adds timestamps to piped output, useful for monitoring long-running computations.

== Development and Research Workflow Tools

- #link("https://direnv.net/")[`direnv`] automatically loads environment variables from `.envrc` files when you enter a directory. Essential for managing project-specific configurations without polluting your global environment. Just `echo 'export API_KEY=foo' > .envrc && direnv allow`.
- #link("https://github.com/jesseduffield/lazygit")[`lazygit`] provides a terminal UI for git that makes complex operations intuitive. Perfect for researchers who want version control without memorizing git commands. Press `?` for help on any screen.
- #link("https://github.com/atuinsh/atuin")[`atuin`] replaces your shell history with a SQLite database, enabling powerful search across all your commands. Sync across machines and never lose that complex data processing pipeline again. Search with `Ctrl-R`.
- #link("https://cli.github.com/")[`gh`] is GitHub's official CLI for managing pull requests, issues, and repositories from the terminal. Clone with `gh repo clone owner/repo`, create PRs with `gh pr create`.

== Agentic Coding Tools

- #link("https://docs.anthropic.com/en/docs/claude-code")[`claude code`] is an AI-powered coding assistant that helps with software development tasks. It can search codebases, write and edit files, run commands, and help debug issues, it can even read Jupyter Notebook files and "see" your images. The VSCod extension is also very nicely integrated, as it can automatically add the lines you select as context.
- #link("https://github.com/reorx/gemini-cli")[`gemini-cli`] is a free AI assistant powered by Google's Gemini models. You can even have Claude Code call Gemini directly for real-time code reviews during development, creating an AI pair programming experience.
- #link("https://herdr.dev")[`herdr`] is a terminal multiplexer built for running coding agents rather than shells. Workspaces, tabs, and panes are scriptable from the command line, so an agent can spawn a sibling session, hand it a task,, and you can attach to any of them to watch or take over. It solves the problem `tmux` only half-solves once you routinely have several agents grinding on different repos: each one gets a named, revisitable home instead of a pane you have to remember.
- #link("https://github.com/agavra/tuicr")[`tuicr`] is a code review TUI with vim keybindings, covering a GitHub PR, a commit range, or just the uncommitted working tree, and it auto-detects `git`, `jj`, or `mercurial`. You scroll a continuous GitHub-style diff and leave line, range, or file-level comments. The part that matters for agentic work is that sessions persist to disk and read both ways: `tuicr review comments` hands your annotations to the agent as structured JSON, and the agent can reply into the same session with `tuicr review add` while you watch. Review the code before it ever reaches GitHub, and hand back a punch list instead of prose.

== My own tools

Agents are only as useful as the interfaces you give them. A coding agent is
very good at composing small text-in, text-out programs and very bad at
clicking through a web app, so the highest-leverage thing you can build is a
CLI wrapper around a service you already pay for. These are the ones I use
daily, mostly my own and all public on #link("https://github.com/edwinhu")[GitHub]:

- #link("https://github.com/edwinhu/workflows")[`workflows`] is a Claude Code plugin holding the skills and agents I use for research, data work, writing, teaching, and legal drafting. Install it with `/plugin marketplace add edwinhu/workflows`. It is the piece that turns a general assistant into one that knows how WRDS joins work, what a Bluebook short form looks like, and which of my notebooks to search before it reaches for the open web.

- #link("https://github.com/edwinhu/google-scholar-cli")[`google-scholar-cli`] searches Scholar, pulls BibTeX by cluster ID, and downloads PDFs through an institutional link resolver, all from one zero-dependency binary. This is the tool that makes "find the paper and add it to my library" a single agent step instead of a browsing session.

- #link("https://github.com/edwinhu/consensus-cli")[`consensus-cli`] queries #link("https://consensus.app")[Consensus] from the terminal. Consensus has become genuinely useful for literature reviews: ask a question and it returns papers that bear on it with the direction and strength of their findings, rather than a keyword ranking you then have to read through to find out who agrees with whom. That is the right shape for a first pass on an unfamiliar literature, and having it as a CLI means an agent can run the pass, pull the hits into #link("https://paperpile.com/")[Paperpile], and hand back a reading list instead of a browser tab.

- #link("https://github.com/tmc/nlm")[`nlm`] is not mine, but it belongs on this list: a CLI for #link("https://notebooklm.google.com/")[NotebookLM], which is otherwise a web app an agent cannot touch. Upload sources, create a notebook, and query it from a script. NotebookLM answers from a fixed corpus you gave it rather than from the open web, so pointing it at a folder of papers and asking questions across all of them is a real research move, and the CLI is what makes it scriptable.

- #link("https://github.com/edwinhu/sec-sro-rss")[`sec-sro-rss`] builds an RSS, Atom, and JSON feed of SEC self-regulatory organization rulemaking off the Federal Register API, since the SEC publishes no usable feed of its own. Subscribe at #link("https://edwinhu.github.io/sec-sro-rss/feed.xml")[`feed.xml`].

= Some python libraries worth learning

== #link("https://requests.readthedocs.io/en/master/")[`requests`]

`requests` is a dead-simple HTTP library for python. Like `curl` it is an essential building tool for working with data that lives on the web (aka scraping).

For example, many websites are now built around REST APIs and deliver JSON payloads. Rather than scraping HTML with something like #link("https://www.crummy.com/software/BeautifulSoup/bs4/doc/")[`BeautifulSoup`], #link("https://lxml.de/")[`lxml`], or worst of all #link("https://www.selenium.dev/")[`Selenium`] you can save yourself a lot of time and preserve your sanity by just using `requests` to get at the underlying data. All you need is the Inspect window of your browser, and some patience and soon you will be an API scraping master.

Bonus tip: https://curl.trillworks.com/ is a great website that converts `curl` statements into `requests` code. This is especially useful because some browsers allow you to copy the results of HTTP requests into `curl`, which you can easily convert into `requests` code!

== #link("https://docs.python.org/3/library/asyncio.html")[`asyncio`]

`asyncio` is part of the python standard library as of python 3.4. It is a library for running concurrent (single-threaded) code, and brings python to the forefront of event-driven programming. That is a fancy way of saying that it is a neat library that can help you write highly parallel code, help you write your own network apps, or even write some pretty fancy scrapers.

`asyncio` has spawned its own ecosystem of libraries, such as #link("https://docs.aiohttp.org/en/stable/")[`aiohttp`] which is like a async version of #link("https://requests.readthedocs.io/en/master/")[`requests`], and #link("https://github.com/Tinche/aiofiles")[`aiofiles`] for dealing with the filesystem asynchronously.

== #link("https://pandas.pydata.org/")[`pandas`]

You have data. You use python. If these conditions apply, then you should use `pandas`. The genius of `pandas` is that provides a `DataFrame`, an indexed, two-dimensional, potentially heterogeneous and hierarchical table of rows and columns. In all likelihood 99% of the data you analyze with statistical techniques will fit into the `DataFrame` structure, and `pandas` makes working with `DataFrames` a breeze with powerful functions for data serialization and transformation.

== #link("https://github.com/ultrajson/ultrajson")[`ujson`]

`ujson` stands for UltraJSON, which is an ultra fast JSON serializer written in C with python bindings. For most applications you can use it as a drop-in replacement for the default python `json` module, which is written in pure python and as such is slower.

== #link("https://github.com/fabiocaccamo/python-benedict")[`benedict`]

`benedict` is a python dictionary subclass that makes navigating dictionaries in python a lot easier. In many ways it is like #link("https://www.crummy.com/software/BeautifulSoup/bs4/doc/")[`BeautifulSoup`], which is very good at working with irregular or malformed HTML/XML data, but for python dictionaries, and JSON-like data. It is not as full-featured as many of the libraries on this list, but it can be very useful if you are working with irregular JSON data.

== #link("http://numba.pydata.org/")[`numba`]

At first glance, `numba` seems like an odd choice for python users. The appeal of python is that it is an interpreted language, and hence does not need to be compiled to run. `numba` is a compiler for python code. However, it is an easy to use, just-in-time (JIT) compiler using the LLVM compiler library. That means that it can take very simple python and `numpy` code and turn it into LLVM compiled code that is nearly as fast as C or FORTRAN code.

A good use case for `numba` is taking an expensive matrix multiplication and re-writing it as a loop. This may seem counterintuitive as the whole point of `numpy` is to abstract away from slow python loops for optimized abstracted matrix operations. Yet these dumb, slow python loops combined with `numba` can be significantly faster than `numpy` counterparts if used correctly.

== #link("https://marimo.io/")[`marimo`]

`marimo` is a reactive Python notebook that solves many pain points of traditional Jupyter notebooks. Unlike Jupyter, `marimo` notebooks are stored as pure Python files, making them git-friendly and importable as modules. The reactive execution model means cells automatically re-run when their dependencies change, eliminating the hidden state issues common in Jupyter. For researchers, this means more reproducible analyses and easier collaboration. Just run `marimo edit notebook.py` to start.

== #link("https://github.com/juba/pyobsplot")[`pyobsplot`]

`pyobsplot` brings Observable Plot to Python, rendering interactive charts from `pandas` or `polars` DataFrames inside Jupyter, `marimo`, or Quarto. Observable Plot is a concise grammar of graphics, so a scatter plot is just `Plot.plot({"marks": [Plot.dot(df, {"x": "x", "y": "y"})]})`, with sensible defaults for scales, legends, and faceting. Output is real JavaScript, so tooltips and zooming work in the browser, and figures can be saved to SVG or PNG for a paper.

== #link("https://pola.rs/")[`polars`]

`polars` is a lightning-fast DataFrame library that often outperforms `pandas` by 10-100x. Written in Rust, it features lazy evaluation, automatic query optimization, and excellent memory efficiency. For researchers working with large datasets, `polars` can process data that would crash `pandas`. The API is expressive: `df.filter(pl.col('x') > 5).group_by('category').agg(pl.col('y').mean())`.

== #link("https://github.com/posit-dev/great-tables")[`great_tables`]

`great_tables` builds finished display tables in Python. It is the same project as R's `gt`, maintained by Posit for both languages, so the grammar carries across if you move between them. A table is split into named parts (title, stub, column spanners, body, footnotes, source note) and formatting is declarative rather than a pile of string munging: `GT(df).fmt_number(columns="ret", decimals=3).tab_spanner("Returns", ["ret", "vol"])`. Useful for turning regression or summary output into something you can drop straight into a paper or a slide, and it exports to HTML, LaTeX, and PNG.

= Some `R` libraries worth learning

== #link("https://www.tidyverse.org/")[`tidyverse`]

`tidyverse` is a metapackage of data analysis tools for `R`. In many ways it is like the `anaconda` default installation in that it includes so many of the essentials. To get started analyzing data in a modern `R` setup you will likely need `ggplot2`, `dplyr`, `stringr`, and `purrr` just to name a few. All of these are part of `tidyverse`.

`tidyverse` also contains one of the most useful packages in any language: `haven`, which allows you to read `SAS` and `Stata` files. Look, we can all pretend like we don't have co-authors that use these languages, or we can deal with it and use `haven`.

== #link(
  "https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html",
)[`data.table`]

`data.table` is #link("https://github.com/Rdatatable/data.table/wiki/Benchmarks-%3A-Grouping")[very fast], and has an intuitive syntax. It is certainly different from `tidyverse::dplyr`, but for those familiar with `pandas`, PyTable, or `sql` it may be more intuitive.

Bonus tip: DataCamp has a great #link("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/datatable_Cheat_Sheet_R.pdf")[cheat sheet] for `data.table`.

== #link("https://gt.rstudio.com/")[`gt`]

`gt` is the `R` half of the same table grammar as `great_tables` above: `gt(df) |> fmt_number(columns = ret, decimals = 3) |> tab_spanner("Returns", c(ret, vol))`. Pair it with `modelsummary` to turn regression output into a table you can send to a journal without hand-editing LaTeX.

== #link("https://www.rdocumentation.org/packages/lfe/versions/2.8-6/topics/felm")[`felm`] and #link("https://github.com/amrei-stammann/alpaca")[`alpaca`]

`felm` and `alpaca` are R packages for linear/logistic regressions with high dimensional fixed effects and clustered standard errors. Both are available on CRAN, and are fairly well documented.

= Other Useful Software

== #link("https://duckdb.org/")[`DuckDB`]

`DuckDB` is a SQL-style database with very convenient syntax for data analysis. It works very well with standard tabular data formats, and plays nicely with python. It is also very fast for analytic workflows, including read/write and processing data. One of the most useful features is the variety of built-in datatypes, such as `LIST` and `STRUCT` which map to python/JSON datatypes. It also allows for nested or composite datatypes, which are often found in real-world data. By default, `DuckDB` operates in-memory databases. In many ways, it is like `SQLite` but designed for data analysis workflows. It also features a lot of useful extensions whic facilitate full text search, JSON querying, reading/writing remote files over HTTP, and reading from `Postgres/SQLite` databases.

`DuckDB` now plays nicely with both python and R, and with their respective dataframes. It is also very very good at reading all sorts of common data files like csv, json, and parquet.

== Typesetting (#link("https://typst.app/")[`Typst`] and #link("https://tectonic-typesetting.github.io/")[`Tectonic`])

`Typst` is what I write in now: a markup-based typesetting system with a real scripting language, incremental compilation fast enough to preview while you type, and error messages that name the problem instead of unwinding a macro expansion. Papers, slides, and course handouts all come out of the same source, and because a document is a program you can compute a number in the document rather than pasting one in and watching it go stale.

Sometimes LaTeX is not optional: a coauthor's file, a journal's class file. `Tectonic` is the answer there, a Rust rewrite of the TeX engine that fetches only the packages a document actually needs from a web bundle, so there is no multi-gigabyte TeX Live install and no `Package not found` on a fresh machine. One `tectonic -X compile paper.tex`, reproducible anywhere.

== Web Scraping APIs (#link("https://www.zyte.com/")[`Zyte`], #link("https://brightdata.com/")[`Bright Data`])

Sometimes the only way to get data is through traditional web scraping. Scraping is #link("https://cdn.ca9.uscourts.gov/datastore/opinions/2022/04/18/17-16783.pdf")[controversial] and at the very least most websites have some sort of rate limiting or bot restrictions. Other websites are weirdly designed and require javascript rendering to be able to access content. A scraping API handles the former by providing headless instances that imitate a real Chrome browser, running through different proxies (including residential IP addresses) and the latter through custom javascript rendering. These services make scraping _much much_ easier in the modern age. They are services you have to pay for, but the rates are reasonable considering that spinning up a custom solution (e.g., multiple AWS instances) is costly and time-consuming. I've used several of these, and after hands-on testing against a genuinely tough Cloudflare-protected target, my clear recommendation now is `Zyte`.

#link("https://www.zyte.com/")[`Zyte API`] is what I reach for first. The big selling point is that it _just works_: it cleared a hard Cloudflare managed-challenge target on default settings, with no special flags, proxy modes, or zone configuration to fiddle with, at roughly 18s/page. Built by the `Scrapy` team, it has a clean, well-documented API with both `httpResponseBody` (static) and `browserHtml` (JS-rendered) modes — you flip one field to add JS rendering. It bills per successful request and has a free tier. Of everything I tested, it required the least setup and the least trial-and-error, which is worth a lot when you just want the data.

The one alternative worth knowing about is #link("https://brightdata.com/")[`Bright Data` Web Unlocker], which has industry-leading anti-bot bypass and is the most economical at large scale — you pay per successful request (roughly \$1.5–3 per 1,000), so failures cost nothing. It cleared the same hard target (around 50s/page) and even returned usable raw HTML without JS rendering. The catch is setup friction: you have to create a "Web Unlocker zone" and, for some accounts, clear KYC before it works. So reach for `Bright Data` if you're scraping at large scale and want the cheapest per-success pricing; otherwise `Zyte` is the easier default.

*Warning:* If you pay for a higher tier with concurrency, do not follow the vendor tutorials and try to use `multiprocessing` or `concurrent.futures` for parallelism. Although it is syntactically simple, they run into the Python GIL and will lock after a few iterations. Instead, use `aiohttp` and just replace the url field with the scraping API url, include your API Key as a parameter, and the url you want to scrape as another parameter.

= Mac Applications for Researchers

== Terminal and Development

- #link("https://wezfurlong.org/wezterm/")[`WezTerm`] / #link("https://ghostty.org/")[`Ghostty`] are modern terminal emulators with GPU acceleration, split panes, and extensive customization. They also provide native image support.

== Productivity Tools

- #link("https://superwhisper.com/")[`Superwhisper`] provides system-wide voice transcription using different transcription models. It is much better than the built-in Apple dictation, and can be much faster than typing. You can also have AI process your transcript directly, so you can for example, dictate some sentences and have it automatically turned into a properly formatted email.

- #link("https://voxtype.io/")[`Voxtype`] is the Linux counterpart: push-to-talk voice-to-text for Wayland, written in Rust and running local Whisper models, so nothing leaves the machine. Hold a hotkey, speak, and the text is typed into whatever window has focus. On #link("https://omarchy.org/")[Omarchy] it ships as an optional one-click install with Waybar and Hyprland integration already wired up, and packages exist for Arch, NixOS, Ubuntu, Debian, and Fedora.

- #link("https://www.homerow.app/")[`Homerow`] enables keyboard-only navigation of macOS by showing letter hints on clickable elements. Essential for reducing mouse usage during long coding or writing sessions.

- #link("https://1password.com/")[`1Password`] is a password manager with good cross-platform support and, more usefully for research work, a CLI (`op`) and SSH agent. Secrets stay out of your dotfiles and scripts: `op read "op://vault/wrds/password"` pulls a credential at runtime, and service accounts scoped to a single vault let an agent or a cron job fetch exactly what it needs and nothing else.

== Knowledge Management

- #link("https://obsidian.md/")[`Obsidian`] is a note-taking app over a plain folder of markdown files, with bidirectional links and backlinks on top. Because the vault is just files, `rg`, `git`, and a coding agent all work on it directly, which matters more than any feature the app itself ships. For research it does double duty: a knowledge graph of concepts and case notes you can actually search, and a corpus you can point an LLM at when you would rather get your own prior reading back than a generic answer.

- #link("https://pwmt.org/projects/zathura/")[`zathura`] is a keyboard-driven document viewer with vim bindings: `j`/`k` to scroll, `/` to search, `tab` for the outline, and no chrome around the page. It reads PDF, DjVu, PostScript, and EPUB through pluggable backends, follows SyncTeX both ways so you can jump between a source line and the rendered page, and reloads on its own when the file changes, which makes it the right pane to leave open next to a Typst or LaTeX document you are recompiling.

- #link("https://paperpile.com/")[`Paperpile`] is a reference manager that integrates seamlessly with Google Docs and Microsoft Word. It automatically extracts metadata from PDFs, syncs across devices, and makes citation formatting painless. The Chrome extension adds papers from Google Scholar with one click.

- #link("https://readwise.io/reader")[`Readwise Reader`] is a read-later app designed for deep reading and annotation. It handles PDFs, web articles, newsletters, and even YouTube videos. The killer feature is its powerful highlighting system that syncs with note-taking apps like Logseq or Obsidian. It also has an MCP, so you can connect it with LLMs like Claude, which then knows everything you have read/highlighted and can help you surface relevant passages or citations.
