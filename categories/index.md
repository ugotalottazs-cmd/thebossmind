---
layout: page
title: Categories
---

# Browse by Category

{% for category in site.categories %}
## [{{ category[0] | capitalize }}](/thebossmind/categories/{{ category[0] }}/)
- **{{ category[1].size }}** posts
{% endfor %}
