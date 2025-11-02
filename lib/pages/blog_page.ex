defmodule PrWebsite.BlogPage do
  use Tableau.Page,
    layout: PrWebsite.RootLayout,
    permalink: "/blog"

  import PrWebsite

  def template(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <!-- Page Header -->
      <div class="md:flex md:justify-between md:items-center w-full mb-10">
        <h1>All posts</h1>

        <!-- Search Input -->
        <input
          id="search-input"
          type="text"
          placeholder="Search posts..."
          class="md:w-72 w-full px-5 py-3 border border-gray-400 dark:text-gray-700 dark:bg-gray-100 rounded-md block ease-in duration-300 dark:focus:border-blue-400 focus:border-blue-400"
        />
      </div>

      <!-- Posts Container -->
      <div id="posts-container" class="not-prose sm:flex flex-wrap w-full">
        <%= for {post, index} <- Enum.with_index(@posts) do %>
          <div class="post-item sm:w-1/2 mb-12" data-title="<%= String.downcase(post.title) %>" data-summary="<%= String.downcase(Map.get(post, :summary, String.slice(post.body, 0..150))) %>">
          <div class="<%= if rem(index, 2) == 0, do: "sm:mr-6", else: "sm:ml-6" %>">
              <!-- Post Date -->
              <div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
                Published <%= Calendar.strftime(post.date, "%B %d, %Y") %>
              </div>

              <!-- Post Title -->
              <a
              href="<%= post.permalink %>"
              class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2"
              >
              <%= post.title %>
              </a>

              <!-- Post Summary -->
              <p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
              <%= Map.get(post, :summary, String.slice(post.body, 0..150) <> "...") %>
              </p>

              <!-- Read More Link with Animated Underline -->
              <a
              href="<%= post.permalink %>"
              class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100"
              >
                <span class="font-medium text-black dark:text-white">Read more</span>
              </a>
            </div>
          </div>
        <% end %>
      </div>

      <!-- No Results Message -->
      <div id="no-results" class="hidden text-center py-8">
        <h3 class="text-xl font-medium text-gray-600 dark:text-gray-400">No posts found matching your search.</h3>
      </div>
    </div>

    <script>
      // Client-side search functionality
      document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('search-input');
        const postsContainer = document.getElementById('posts-container');
        const noResults = document.getElementById('no-results');
        const posts = document.querySelectorAll('.post-item');

        function filterPosts(query) {
          const lowerQuery = query.toLowerCase();
          let visibleCount = 0;

          posts.forEach(post => {
            const title = post.dataset.title || '';
            const summary = post.dataset.summary || '';

            if (title.includes(lowerQuery) || summary.includes(lowerQuery)) {
              post.style.display = '';
              visibleCount++;
            } else {
              post.style.display = 'none';
            }
          });

          // Show/hide no results message
          if (visibleCount === 0 && query.length > 0) {
            noResults.classList.remove('hidden');
          } else {
            noResults.classList.add('hidden');
          }
        }

        // Initial state - show all posts
        filterPosts('');

        // Listen for input changes
        searchInput.addEventListener('input', function(e) {
          filterPosts(e.target.value);
        });
      });
    </script>
    """
  end
end
