---
layout: page
permalink: /reading/
title: reading list
description: Papers by others that I have enjoyed and would recommend, each with a short personal note. These are not my own publications.
nav: true
nav_order: 2
---

<!--
Diese Liste wird aus _bibliography/reading.bib erzeugt (NICHT papers.bib).
Neues Paper hinzufügen: einen BibTeX-Eintrag in reading.bib einfügen, dazu die
Felder  mycomment = {dein Kommentar}  und  sortkey = {NN}  (Reihenfolge).
Die Liste ist bewusst NICHT nach Jahr sortiert, sondern nach sortkey.
-->

These are papers by **others** that I have enjoyed and recommend — not my own work
(for that, see my [publications](/publications/)). Each comes with a short personal note.

<div class="publications">

{% bibliography --file reading --group_by none --sort_by sortkey --order ascending %}

</div>
