# Writing & LaTeX Guidelines for This Repository

All prose in this paper must follow the rules below. When writing or revising
any `.tex` file, apply them and prefer a targeted edit over a rewrite.

The governing idea: readers judge prose clear when its **characters
are subjects** and its **actions are verbs**. Revise by diagnosing where that
fails, not by following taste.

---

## 0. Project file organization

Keep `main.tex` as a thin spine that only sets up the preamble and `\input`s
content. One logical unit per file:

```
main.tex            preamble + \input of every section, in reading order
refs.bib            bibliography
sections/<section>.tex   one file per section (introduction, background, ...)
tables/<name>.tex   one tabular per table (no float)
figures/<name>.pdf  one graphic per figure, or
figures/<name>.tex  one TikZ picture per figure (no float)
algorithms/<name>.tex  one algorithm body per algorithm, if any (no float)
listings/<name>.tex    one code listing per file, if any (no float)
```

Rules:

- **One section per file in `sections/`.** Each `sections/*.tex` holds exactly
  one top-level `\section{}` (with its subsections). `main.tex` `\input`s them
  in order; never inline a section body in `main.tex`.
- **Floats live in the section, content lives in its folder.** The section
  file owns the outer environment (`table`, `figure`, `wraptable`,
  `wrapfigure`, `algorithm`, …) together with its `\caption`, `\label`,
  placement, and sizing. Files in `tables/`, `figures/`, `algorithms/`, and
  `listings/` hold only the inner content. Reason: a caption must be edited
  against the prose around it, and the section decides whether the exhibit
  floats, wraps text, or spans half the page.
- **Tables:** a file in `tables/` contains only the `tabular` (or
  `tabularx`, `booktabs` rules, etc.), never `\begin{table}`, `\caption`, or
  `\label`. The section wraps it:
  ```latex
  \begin{table}[t]
    \centering
    \caption{…}\label{tab:risks}
    \input{tables/risks}
  \end{table}
  ```
- **Figures:** a figure is either a graphic (`figures/<name>.pdf`, pulled in
  with `\includegraphics`) or a `.tex` file holding only the
  `tikzpicture` (or other drawing code), never `\begin{figure}`, `\caption`,
  or `\label`. The section wraps it:
  ```latex
  \begin{figure}[t]
    \centering
    \includegraphics[width=\linewidth]{figures/pipeline.pdf}
    % or: \input{figures/pipeline}
    \caption{…}\label{fig:pipeline}
  \end{figure}
  ```
- **Algorithms:** a file in `algorithms/` holds only the algorithm body
  (e.g. the `algorithmic` block); the section supplies the `algorithm` float,
  caption, and label.
- **Code listings go in a `figure` environment.** A file in `listings/`
  holds only the `lstlisting`/`minted` block (or an `\lstinputlisting` of a
  source file). Never use the listing package's own `float`, `caption`, or
  `label` options, and do not declare a separate `listing` float. The section
  wraps the listing in a `figure` (or `wrapfigure`), so it gets the same
  control over placement, width, and caption as any other figure, and a
  `fig:` label:
  ```latex
  \begin{figure}[t]
    \centering
    \input{listings/adapter}
    \caption{…}\label{fig:adapter}
  \end{figure}
  ```
- **Name the file after its label suffix.** Label `tab:skeletons` →
  `tables/skeletons.tex`; `fig:architecture` → `figures/architecture.pdf` or
  `figures/architecture.tex`; `alg:router` → `algorithms/router.tex`; a
  listing labeled `fig:adapter` → `listings/adapter.tex`. Keep
  labels prefixed (rule 47) and reference them with `\autoref`.
- **Place the float near the first `\autoref`** to it so it lands on the
  right page; floats reposition themselves, so exact placement is a hint, not
  a guarantee.

---

## 1. Clarity — sentences

1. **Make main characters the subjects of sentences.** This is the first
   principle. Do not bury the agent in a prepositional phrase or delete it.
   - Bad: _A decision by the dean in regard to the funding of the program is necessary._
   - Good: _The dean must decide whether to fund the program._
   1a. **We are the character of our contributions.** The authors propose,
   build, measure, show, and describe; the paper, its sections, and its
   exhibits do not. Make _we_ the subject of every act of authorship
   (the one narrow exception for navigational sentences is in rule 47a).
   - Bad: _This paper proposes a benchmark._ / _Section 4 evaluates the judge._ / _\autoref{tab:main} presents the results._
   - Good: _We propose a benchmark._ / _We evaluate the judge in \autoref{sec:eval}._ / _We report the results in \autoref{tab:main}._
   - A system or model stays the subject when the sentence describes what
     _it_ does (_The scheduler routes budget across directions_); only acts
     of authorship move to _we_.
   - Keep the tense of these acts consistent through a passage: present for
     what the paper does (_we propose, we show, we report_), past for
     experiments already run (_we trained, we ran_). Do not switch between
     them for the same kind of act (rule 33).
2. **Make important actions verbs; avoid nominalizations** (verbs/adjectives
   turned into nouns: _evaluation, ability, implementation_).
   - Bad: _We made a proposal to use…_ → Good: _We proposed to use…_
   - Bad: _Our lack of data prevented evaluation of…_ → Good: _Because we lacked data, we could not evaluate…_
3. **Keep nominalizations only when** they refer back to a previous sentence
   (_These results…_), replace an awkward _the fact that_, name what would be a
   verb's object (_her request_), or name a familiar concept (_taxation_).
4. **Get to the subject quickly, then to its verb.** Avoid long introductory
   phrases and long whole-subjects before the verb.

## 2. Clarity — flow

5. **Old before new.** Begin a sentence with information the reader already
   knows (from the previous sentence or shared context); put new, complex
   information at the **end**.
6. **Stress position.** The end of a sentence is emphatic—close on the words
   that matter, and introduce unfamiliar technical terms there, not at the
   start.
7. **Consistent topic strings.** Through a passage, keep subjects/topics short,
   concrete, and consistent so a reader sees what the passage is "about." Do
   not vary the subject for variety's sake. Cohesion of a passage outranks the
   clarity of any single sentence.
8. **No throat-clearing.** Cut metadiscourse pile-ups before the subject (_And
   therefore, it is important to note that…_), and do not wrap a finding in
   _it was observed that_; state the finding and cite its evidence.
   - Bad: _It was observed that accuracy drops with depth._
   - Good: _Accuracy drops with depth (\autoref{fig:depth})._
9. **Don't fake coherence with connectives.** Use _but/however_ to qualify and
   _therefore/so_ to conclude, but do not lace prose with _moreover, also,
   furthermore_ to simulate logic. A few per page at most.

## 3. Sentence shape

10. **Unpack noun stacks.** Rewrite a pile of three or more nouns as a phrase
    with prepositions, a relative clause, or a verb. Hyphenate a true compound
    modifier before a noun (_append-only log_, _closed-question jury_).
    - Bad: _the LLM-judge reward-hacking detection rate estimate_
    - Good: _our estimate of how often the LLM judge detects reward hacking_
11. **Don't interrupt subject and verb, or verb and object.** Move the
    interrupting clause to the front or the end.
    - Bad: _The judge, because it sees only final outputs, misses hacks._
    - Good: _Because the judge sees only final outputs, it misses hacks._
12. **Put the main claim in the main clause.** Demote background and cause to
    a subordinate clause, and replace a bare _and_ with the real relation
    (_because, but, so_).
    - Bad: _The grader checks only outputs, and agents learn to hard-code answers._
    - Good: _Because the grader checks only outputs, agents learn to hard-code answers._
13. **Stop sprawl.** Give each sentence one new claim; split a sentence that
    carries two. Do not chain relative clauses (_which… which… that…_). To
    extend a sentence, add a resumptive modifier (repeat a key word), a
    summative modifier (sum up the clause), or a free modifier (a trailing
    participle phrase).
    - Bad: _…uses a scheduler, which allocates budget, which is derived from scores that…_
    - Good: _The scheduler reallocates budget every round, a design that keeps weak directions alive._
14. **Keep coordinated items parallel.** Items in a series, list, or set of
    headings take the same grammatical form, and should be logically parallel
    too. Order them short to long when meaning allows.
    - Bad: _We measure coverage, how novel solutions are, and do agents hack the grader?_
    - Good: _We measure coverage, novelty, and grader hacking._
15. **Place modifiers next to what they modify.** Put _only, just, almost_
    directly before the word they limit. An opening participle phrase must
    modify the sentence's subject.
    - Bad: _We only evaluate on Chip-Bench tasks._ → Good: _We evaluate only on Chip-Bench tasks._
    - Bad: _Trained for 10k steps, the results show…_ → Good: _Trained for 10k steps, the agent reaches…_
16. **Give every _this_ and _it_ one clear antecedent.** When _this_ could
    point to more than one thing, follow it with a noun.
    - Bad: _The judge sees only the final diff. This inflates scores._
    - Good: _The judge sees only the final diff. This restricted view inflates scores._

## 4. Concision

Apply the six cuts, in order:

17. **Delete meaningless words:** _kind of, actually, really, basically,
    virtually, generally, given, particular, various, certain, simply._
18. **Delete doubled words:** _full and complete, each and every, hopes and
    desires._
19. **Delete what readers can infer:** redundant modifiers (_future plans,
    final outcome, terrible tragedy_) and redundant categories (_period of
    time → period_, _pink in color → pink_).
20. **Replace a phrase with a word:** _in order to → to_, _due to the fact
    that → because_, _has the ability to → can._
21. **Change negatives to affirmatives:** _not many → few_, _not able → unable._
22. **Delete useless adjectives and adverbs.**

Keep the style "as simple as possible, but no simpler"—_as complex as
necessary, but no more._

## 5. Claims and terms

23. **Match certainty to the evidence.** Cut _clearly, obviously,
    undoubtedly_; readers doubt what they are told is obvious. Say _shows_
    only when the evidence shows it, and _suggests_ when it suggests.
    - Bad: _Our method clearly proves that RL causes reward hacking._
    - Good: _Our results suggest that RL training increases reward hacking on 7 of 10 tasks._
24. **Replace a vague claim with its number.**
    - Bad: _substantially improves pass rate_
    - Good: _raises pass@1 from 41.2% to 53.8%_
25. **Complete every comparison.** Name both sides and keep them parallel.
    - Bad: _Our scheduler is more sample-efficient._
    - Good: _Our scheduler reaches 80% success in fewer episodes than uniform sampling does._
26. **Use one term per concept, and define it at first use.** Do not swap
    synonyms for variety (_task_ in one section, _environment_ or _problem_ in
    another). Define every specialized term and acronym where it first
    appears; write for a reviewer who is not an expert on the topic. Carry the
    key terms named in the introduction's point sentence into the section
    headings, unchanged.

## 6. Voice, grammar, usage

27. **Prefer the active voice.** Use the passive only with reason: the agent is
    obvious or irrelevant (_The president was reelected_), the passive yields a
    shorter subject or a better old→new ordering, or it keeps a consistent
    topic string. Never use the passive to hide who acts.
28. **Avoid existential _there is / there are_**; recast with a real subject and
    verb.
29. **_that_ vs _which_:** _that_ for restrictive clauses (no comma); _which_
    for nonrestrictive (with comma).
30. **_fewer_ vs _less_:** _fewer_ for count nouns, _less_ for mass nouns;
    likewise _number_ vs _amount_.
31. **_compared with_** (assessing similarity/difference) vs **_compared to_**
    (likening). Default to _compared with_ for results.
32. **Articles:** every singular count noun needs an article; use _the_ only
    when the referent is uniquely identifiable.
33. **Tense:** present for established facts and what the paper does; past for
    completed experiments and prior work's specific findings.
34. **Section titles in sentence case**, applied consistently.
35. **No comma splices.** Join two independent clauses with a conjunction, a
    semicolon, or a period, never a bare comma. Put a semicolon before
    _however/therefore_ and a comma after it.
    - Bad: _The judge agrees, the proxy does not._ / _C is unsafe, however Rust is safe._
    - Good: _The judge agrees, but the proxy does not._ / _C is unsafe; however, Rust is safe._
36. **Usage pairs:**
    - _because_ for cause; _since_ for time.
    - _due to_ only after a form of _be_ (_the drop is due to…_); otherwise _because of_.
    - _data_ and _criteria_ are plural (_the data are_; one _criterion_).
    - _X comprises A and B_, not _is comprised of_.
    - no _etc._ after _such as_ or _e.g._
    - _respectively_ only to pair two ordered lists.
37. **Serial comma** in every series (_A, B, and C_). Never start a sentence
    with a numeral; recast or spell it out.
38. **Don't over-correct.** Beginning a sentence with _And_ or _But_ is fine,
    and so is a split infinitive. Revise these only when overused.

## 7. Document & paragraph structure

39. **Open every unit—document, section, paragraph—with a short framing
    segment, and end that segment with a point sentence** that states the unit's
    point and names the key terms the rest develops.
40. **The introduction** motivates with a problem the reader cares about, then
    ends by stating the main point/contribution and the concepts that follow.
    - State the problem as what readers do not know, then its cost: _But we do
      not know whether hacking stems from the reward or the environment;
      without that, we cannot design either._ Prefer this to a direct question
      (_What drives agents to hack?_).
    - Show why the work matters (new problem, new or better solution, strong
      results), what is novel in the design, why the results are correct, and
      why the evaluation is relevant and comprehensive.
41. **The conclusion** mirrors the introduction: restate the point, its
    significance, and what remains open.
42. **Relevance:** every sentence in a unit must visibly serve the unit's
    point (context, point, reason, evidence, method, or counter-view).
43. **Order parts** chronologically, coordinately, or logically—and signal
    which. Do not default to narrating your own thinking.
44. **Budget revision time on beginnings**: the intro, then section openings,
    then paragraph openings, then sentence openings.

## 8. LaTeX

45. **Engine:** pdfLaTeX, LuaLaTeX, or XeLaTeX; follow the venue template.
46. **Bibliography:** keep every entry in one `.bib` file and cite through the
    template's system (BibLaTeX + biber, or BibTeX + natbib). Never hand-write
    a reference list.
    46a. **Source every scientific entry from an official export.** Never
    type a paper's fields from memory.
    - **Published papers** (journal or conference): export BibTeX from the
      official DOI, e.g.
      `curl -LH "Accept: application/x-bibtex" https://doi.org/<doi>`, or the
      publisher's "cite" export. Cite the published version, not the
      preprint, and keep the `doi` field.
    - **Fallback:** if the paper has no DOI (or is only a preprint), use the
      arXiv export, `https://arxiv.org/bibtex/<arxiv-id>`. If the paper
      appeared at a venue without a DOI (e.g. OpenReview), keep the venue as
      `booktitle` and add its `url`.
    - **Every scientific article carries a `doi` or a `url`.**
    - **Non-scholarly sources** (blogs, company posts, news media such as the
      WSJ, documentation, code repositories) need no DOI. Use `@misc`/`@online`
      with author or organization, title, date, `url`, and access date.
    - **If no official export exists,** write the entry by hand from the
      paper itself, put a comment directly above it in the `.bib` file
      (`% TODO(citation): no DOI or arXiv export found; fields copied from
      <source>`), and tell the user which keys need checking.
47. **Cross-references:** load `hyperref` (directly or through the class) and
    use **`\autoref{}`** instead of hand-typing _Table_/_Figure_/_Section_
    before `\ref`. Reword so an `\autoref` never starts a sentence (it
    expands lowercase). Prefix labels `sec:`, `fig:`, `tab:`, `alg:`, `eq:`,
    `thm:`, `lem:`.
    47a. **Exhibits are not characters.** Do not make a figure, table,
    algorithm, listing, or section the subject of a sentence (_Figure 3
    describes the loop_). Recast with _we_ as the subject (_We depict the
    loop in \autoref{fig:loop}_) or, often better, state the claim and cite
    the exhibit parenthetically (_The scheduler routes budget across
    directions (\autoref{fig:loop})_). See rule 1a.
    Exception, to use only when a recast reads worse: a purely navigational
    sentence whose point is what an exhibit contains, not a claim
    (_\autoref{tab:analogy} lists the four mappings_), may keep the exhibit
    as subject, mid-sentence per rule 47. Try the _we_ form first (_We list
    the four mappings in \autoref{tab:analogy}_).
48. **Numbers ≥ 1000:** load `siunitx` and use `\num{8316}`, never a hand-typed
    `8{,}316`. Leave 4-digit years plain.
49. **Math vs text in subscripts and superscripts:** italics denote variables
    only. Use `$t_\text{max}$`, not `$t_{max}$`; `$W^\text{enc}$`, not
    `$W^{enc}$`. Keep an index italic: `$x^{(i)}$`.
50. **Set named operators upright:** `\log`, `\exp`,
    `\operatorname{softmax}`, and `\mathrm{d}x` in integrals. Declare
    recurring ones once in the preamble
    (`\DeclareMathOperator*{\argmax}{arg\,max}`). Never `$softmax(z)$` or
    `$argmax_a$`.
51. **Fix the notation once.** Pick one convention for vectors and matrices
    (e.g. bold via `\bm{x}`, `\bm{W}`), define it as preamble macros, and keep
    one symbol per quantity throughout. Refer to every displayed equation in
    the text, and define each new symbol in the sentence right after it.
52. **Units and quantities:** use `siunitx` (`\qty{5}{\hour}`, `\SI`) rather
    than hand-formatting.
53. **Quotes/dashes:** ` ``…'' ` for quotes; `--` for numeric ranges.
54. **No em dashes.** Do not use `---` in prose. Recast with a colon
    (elaboration), parentheses (aside), a semicolon (linked clauses), or two
    sentences. The rule holds across every `.tex` file in this repo, not only
    the abstract.
55. **Never hand-type author names next to a citation.** When prose names the
    authors of a cited work as the sentence's characters (_X said/argues/
    proposed/showed…_), use `\citet{key}` as the name (_\citet{brown2024monkeys}
    studied…_), never a typed _Brown et al._ or bare surname, and drop the
    then-redundant `\citep`. Exception: when the bib entry's `author` field is
    not the person being named (e.g. a talk published by its venue), keep the
    typed name with `\citep`.
56. **Inline lists use `enumerate*`, never hand-typed markers.** For an
    enumeration inside a sentence, load `\usepackage[inline]{enumitem}` and
    let it number the items; never type `(i)~`, `(ii)~`, `1)`, or `(a)` by
    hand. Keep the items parallel (rule 14).
    ```latex
    Four constructs vote:
    \begin{enumerate*}[label=(\roman*)]
      \item \emph{belief grounded}, …;
      \item \emph{assertion within evidence}, …; and
      \item \emph{reliance tested}, ….
    \end{enumerate*}
    ```
    Use a displayed `enumerate` or `itemize` only when items run longer
    than a sentence or need their own paragraphs.
