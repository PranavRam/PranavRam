---
layout: PrWebsite.RootLayout
title: "#livebook"
permalink: "/tags/livebook/"
---

<div class="flex justify-between items-center mb-8">
  <h1>#livebook</h1>
  <input type="search" id="post-search" placeholder="Search posts..." class="w-64 px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400">
</div>

<div id="posts-list">
<div class="not-prose sm:flex flex-wrap">
<div class="sm:w-1/2 mb-12">
<div class="sm:mr-6">
<div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
Published March 31, 2025
</div>
<a href="/posts/using-moonshine-for-speech-to-text-with-elixir-and-onnx/" class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2">
Using Moonshine for Speech-to-Text with Elixir and ONNX
</a>
<p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
Learn how to integrate Moonshine, a real-time speech-to-text model, with Elixir using ONNX and Livebook for interactive audio transcription.
</p>
<a href="/posts/using-moonshine-for-speech-to-text-with-elixir-and-onnx/" class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100">
<span class="font-medium text-black dark:text-white">Read more</span>
</a>
</div>
</div>

</div>

</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('post-search');
  const postsList = document.getElementById('posts-list');
  const postCards = postsList.querySelectorAll('.sm\\:w-1\\\/2');

  searchInput.addEventListener('input', function() {
    const query = this.value.toLowerCase().trim();
    
    postCards.forEach(card => {
      const postText = card.textContent.toLowerCase();
      if (postText.includes(query)) {
        card.style.display = 'block';
      } else {
        card.style.display = 'none';
      }
    });
  });
});
</script>
