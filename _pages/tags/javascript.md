---
layout: PrWebsite.RootLayout
title: "#javascript"
permalink: "/tags/javascript/"
---

<div class="flex justify-between items-center mb-8">
  <h1>#javascript</h1>
  <input type="search" id="post-search" placeholder="Search posts..." class="w-64 px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400">
</div>

<div id="posts-list">
<div class="not-prose sm:flex flex-wrap">
<div class="sm:w-1/2 mb-12">
<div class="sm:mr-6">
<div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
Published March 24, 2019
</div>
<a href="/posts/node-red-hot-chilli-peppers-tour-scrapper-with-cheerio-and-simple-crawler/" class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2">
Node: Red Hot Chilli Peppers Tour Scrapper With Cheerio and Simple Crawler
</a>
<p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
Learn how to scrape concert information from the Red Hot Chili Peppers' tour website using Node.js, Cheerio, and Simple Crawler, and transform the data through a series of middleware plugins.
</p>
<a href="/posts/node-red-hot-chilli-peppers-tour-scrapper-with-cheerio-and-simple-crawler/" class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100">
<span class="font-medium text-black dark:text-white">Read more</span>
</a>
</div>
</div>

<div class="sm:w-1/2 mb-12">
<div class="sm:ml-6">
<div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
Published March 03, 2019
</div>
<a href="/posts/react-native-responsive-scrollviews/" class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2">
React Native: Responsive ScrollViews
</a>
<p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
Learn how to create a responsive scrollview in React Native to handle content larger than the screen, ensuring smooth user experience across different device sizes.
</p>
<a href="/posts/react-native-responsive-scrollviews/" class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100">
<span class="font-medium text-black dark:text-white">Read more</span>
</a>
</div>
</div>

<div class="sm:w-1/2 mb-12">
<div class="sm:mr-6">
<div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
Published February 17, 2019
</div>
<a href="/posts/forms-in-react-native-with-formik-and-yup/" class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2">
Forms in React Native with Formik and Yup
</a>
<p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
Learn how to create and manage forms in React Native using Formik and Yup, including validation and error handling, in this comprehensive guide.
</p>
<a href="/posts/forms-in-react-native-with-formik-and-yup/" class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100">
<span class="font-medium text-black dark:text-white">Read more</span>
</a>
</div>
</div>

<div class="sm:w-1/2 mb-12">
<div class="sm:ml-6">
<div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
Published July 18, 2015
</div>
<a href="/posts/ui-components-with-d3js/" class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2">
UI Components with d3.js
</a>
<p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
Explore how to use d3.js beyond data visualizations by building a reusable Evidence Box UI component with a header, body, and interactive open/close functionality.
</p>
<a href="/posts/ui-components-with-d3js/" class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100">
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
