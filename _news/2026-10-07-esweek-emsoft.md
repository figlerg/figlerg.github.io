---
layout: post
title: Two talks at ESWEEK in Barcelona
description: Presented our paper on uniform sampling for Timed Regular Expressions at EMSOFT '26, and stepped in to present a second paper on spatial resiliency.
date: 2026-10-07 10:00:00+0200
inline: false
related_posts: false
---

In October I presented our paper on *Uniform Sampling for Timed Regular Expressions* at
**EMSOFT '26**, part of ACM/IEEE Embedded Systems Week (ESWEEK) in Barcelona.

{% include figure.liquid path="assets/img/news/esweek26-emsoft-talk.jpg" class="img-fluid rounded z-depth-1" alt="Presenting Uniform Sampling for Timed Regular Expressions at EMSOFT '26 in Barcelona" %}

When testing real-time systems, you don't want your test suite to accidentally favor
certain behavior over others. Our approach deals with this problem by sampling uniformly
from timed languages. Essentially, we are being "fair" when selecting test cases, meaning
each test adds statistical confidence that the system is safe.

This is the peer-reviewed publication following up on my Master's thesis at TU Wien, AIT
and Verimag, and I am very happy that this topic close to my heart finally found a good
audience. I am very grateful to my co-authors: my supervisors Dejan Ničković and Ezio
Bartocci, as well as Thao Dang, Nicolas Basset and Benoît Barbot, who welcomed me in
France to work on this topic.

I also jumped in on short notice to present the paper *Spatial Resiliency in Cyber-Physical
Systems* on behalf of Zeyu Zhang and his co-authors. A solar-powered Mars rover is
dependent on getting enough sun to recharge its batteries. Some paths may favor
recoverability (how quickly it reaches a sunny spot), some persistency (staying on a sunny
path for as long as possible). Their logic, SpaRS, lets us reason about both properties
quantitatively.

<div class="row mt-3">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/news/esweek26-spars-poster.jpg" class="img-fluid rounded z-depth-1" alt="At the Spatial Resiliency in Cyber-Physical Systems poster" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/news/esweek26-spars-talk.jpg" class="img-fluid rounded z-depth-1" alt="Presenting the SpaRS quantitative semantics" %}
  </div>
</div>

<!-- TODO Felix: Sobald die Proceedings da sind, hier DOI/Links der beiden Paper ergänzen. -->
