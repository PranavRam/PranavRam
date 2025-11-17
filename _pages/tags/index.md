---
layout: PrWebsite.RootLayout
title: "Tags"
permalink: "/tags/"
---

<div class="flex justify-between items-center mb-8">
  <h1>Tags</h1>
  <input type="search" id="tag-search" placeholder="Search tags..." class="w-64 px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400">
</div>

<div id="tags-list" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
  <a href="/tags/cheerio.js/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#cheerio.js</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/clojure/script/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#clojure/script</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/d3.js/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#d3.js</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/data manipulation/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#data manipulation</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/elixir/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#elixir</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/javascript/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#javascript</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(4)</span>
  </a>

  <a href="/tags/livebook/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#livebook</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/meander/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#meander</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/onnx/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#onnx</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/react-flow/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#react-flow</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/react-native/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#react-native</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(2)</span>
  </a>

  <a href="/tags/simple-crawler/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#simple-crawler</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

  <a href="/tags/speech-to-text/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">#speech-to-text</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(1)</span>
  </a>

</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('tag-search');
  const tagsList = document.getElementById('tags-list');
  const tagLinks = tagsList.querySelectorAll('a');

  searchInput.addEventListener('input', function() {
    const query = this.value.toLowerCase().trim();
    
    tagLinks.forEach(link => {
      const tagText = link.textContent.toLowerCase();
      if (tagText.includes(query)) {
        link.style.display = 'block';
      } else {
        link.style.display = 'none';
      }
    });
  });
});
</script>
