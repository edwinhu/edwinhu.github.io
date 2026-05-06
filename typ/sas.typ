#import "templates/website-head.typ": website-page

#show: website-page.with(title: "SAS Macros", base: "..")

#context {
  if target() == "html" {
    html.elem("h1", attrs: (class: "title"), smallcaps[SAS Macros])
  } else {
    align(center, text(size: 2em, smallcaps[SAS Macros]))
  }
}

A collection of SAS Macros that I frequently use and occasionally update.

The full repo can be found at #link("http://github.com/edwinhu/sas")[github.com/edwinhu/sas].

#outline(depth: 2, title: "Table of Contents")

= CRSP

== #link("https://github.com/edwinhu/sas/blob/master/CC_LINK.sas")[CC_LINK]

Links COMPUSTAT GVKEYs to CRSP PERMNOs.

Takes a file which contains GVKEYs and dates and merges in the appropriate PERMNOs. This handles a lot of silly merge issues.

- `dsetin`: Input Dataset
- `dsetout`: Output Dataset Name, default `compx`
- `datevar`: date variable to use (`datadate`, `rdq`)
- `keep_vars`: variables to keep

```sas
%INCLUDE "~/git/sas/CC_LINK.sas";
%CC_LINK(dsetin=&syslast.,
    dsetout=compx,
    datevar=datadate,
    keep_vars=);
```

= COMPUSTAT

== #link("https://github.com/edwinhu/sas/blob/master/COMP_EAD.sas")[COMP_EAD]

Gets quarterly earnings announcement dates from COMPUSTAT and fetches CRSP PERMNOs. Makes a file `comp_ead_events`.

- `comp_vars`: list of COMPUSTAT variables to fetch
- `filter`: filters to place on COMPUSTAT quarterly

```sas
%INCLUDE "~/git/sas/COMP_EAD.sas";
%COMP_EAD(comp_vars=gvkey fyearq fqtr conm datadate rdq
    epsfxq epspxq
    prccq ajexq
    spiq cshoq cshprq cshfdq
    saleq atq
    fyr datafqtr,
    filter=not missing(saleq) or atq>0
    );
```

= Utilities

== #link("https://github.com/edwinhu/sas/blob/master/FF93_FACTORS.sas")[FF93_FACTORS]

Replicates Fama-French (1993) SMB & HML Factors. Currently obtaining correlations of 99.5% (SMB) 97.8% (HML) for sample period 1975 to 2019.

Also useful in case you want to get the breakpoints or portfolio compositions.

== #link("https://github.com/edwinhu/sas/blob/master/EVENT_MACROS.sas")[EVENT_MACROS]

A collection of event study macros adapted from WRDS.

`%EVENT_SETUP` sets the global variables, including the start and end dates of the estimation and event windows. It also sets the formula to use for the abnormal returns.

`%EVENT_EXPAND` does the bulk of the merging of datasets, creating the actual windows and ultimately the output file `&prefix._expand`.

`%EVENT_STATS` computes abnormal returns, and then the summary statistics. The output file `&prefix._car` contains the event-window data with abnormal returns.

```sas
%INCLUDE "~/git/sas/EVENT_MACROS.sas";
%EVENT_SETUP(pref=,
    crsp_lib=crspm,
    frequency=d,
    date_var=event_date,
    id_var=permno,
    model=ffm,
    ret_var=retx,
    est_per=252, gap_win=30,
    beg_win=-30, end_win=120
    );
%EVENT_EXPAND(lib=user, debug = n);
%EVENT_STATS(prefix = ,
    dsetin = ,
    group = ,
    filter = and shrcd in (10,11) and exchcd in (1,2,3),
    debug= = n
    );
```

== #link("https://github.com/edwinhu/sas/blob/master/MERGE_ASOF.sas")[MERGE_ASOF]

Does an as-of or "window" merge, e.g., COMPUSTAT yearly with CRSP monthly, or TAQ quotes with TAQ trades.

Analogous to #link("https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.merge_asof.html")[`pandas.merge_asof`], #link("https://www.rdocumentation.org/packages/data.table/versions/1.12.2/topics/setkey")[R `data.table` rolling joins], and #link("https://code.kx.com/q/ref/asof/")[kdb+ `asof`].

- `a`: dataset a
- `b`: dataset b
- `merged`: output merged dataset
- `idvar`: firm identifier (`permno`)
- `datevar`: date variable to use (`date`)
- `sort_statement`: defaults to `idvar datevar` but can be customized
- `num_vars`: numeric variables from b to merge in
- `char_vars`: character variables from b to merge in

```sas
%INCLUDE "~/git/sas/MERGE_ASOF.sas";
%MERGE_ASOF(a=,b=,
    merged=,
    num_vars=);
```

== #link("https://github.com/edwinhu/sas/blob/master/PARFOR.sas")[PARFOR]

A parallel FOR loop SAS Macro.

If you have huge files it is often better to use Split-Apply-Combine processing. For example processing daily trades by year can be done by splitting the dataset into yearly datasets and doing the processing in a parallel FOR loop.

This Macro spawns multiple SAS processes in the background to make parallel processing easy. The Macro waits until all processes are complete before returning control to the user.

*WARNING*: There is no built-in resource control (RAM/CPU) so make sure to test your code on one group at a time before spawning too many concurrent processes!

```sas
%INCLUDE "~/git/sas/PARFOR";
%LET FUNC = %STR(
    proc print data=perf_&yyyy.(obs=25);
    var exret: ret:;
    run;
);
%PARFOR(FUNC=&FUNC.);
```

== #link("https://github.com/edwinhu/sas/blob/master/RESAMPLE.sas")[RESAMPLE]

Resample and forward-fill data from low to high frequency. Commonly used to sample low frequency COMPUSTAT data before merging with higher frequency CRSP data. It is more efficient to use `MERGE_ASOF` for this specific task.

- `lib`: input dataset library
- `dsetin`: input dataset
- `dsetout`: output (resampled) dataset
- `datevar`: date variable to resample
- `idvar`: group by id variable
- `infreq`: input frequency
- `outfreq`: output (higher) frequency
- `alignment`: date alignment (E,S,B)
- `debug`: keep or delete temporary datasets

```sas
%INCLUDE "~/git/sas/RESAMPLE.sas";
%RESAMPLE(lib=sashelp, dsetin=citiyr, outfreq=monthly, idvar=, datevar=date);
```

== #link("https://github.com/edwinhu/sas/blob/master/ROLL_REG.sas")[ROLL_REG]

Runs rolling regressions in a computationally efficient way, taking advantage of SAS SSCP matrices.

- `dsetin`: input dataset
- `id`: id variable
- `date`: date variable
- `y`: dependent variable
- `x`: independent variable
- `ws`: window size
- `debug`: debug mode (`n`)

```sas
%INCLUDE "~/git/sas/ROLL_REG.sas";
%ROLL_REG(dsetin=,
          id=permno,
          date=date,
          y=exret,
          x=mktrf,
          ws=60,
          debug=n);
```
