defmodule PrWebsite.HomePage do
  use Tableau.Page,
    layout: PrWebsite.RootLayout,
    permalink: "/"

  import PrWebsite

  def template(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <!-- Hero Section with Avatar and Name -->
      <div class="flex flex-row items-center mb-4">
        <div class="flex items-center w-32 h-32 not-prose">
          <img
            src="/images/avatar.jpg"
            alt="Pranav Ram"
            class="rounded-[50%] my-0"
            loading="lazy"
          />
        </div>
        <h1 class="font-medium pl-4 xl:pl-8 text-4xl">Pranav Ram</h1>
      </div>

      <!-- Description -->
      <div class="w-full prose dark:prose-invert lg:prose-xl prose-h1:mb-0 lg:prose-h1:mb-0 prose-h3:mb-0 lg:prose-h3:mb-0 prose-p:my-2 lg:prose-p:my-2">
        <p class="pt-4">
          Interested in solving challenging engineering and data science problems? <br />
          Join us at <a href="https://www.fyndna.com" target="_blank">FYN<strong>DNA</strong></a>!
        </p>
      </div>

      <!-- Recent Posts -->
      <div class="mt-16 w-full">
        <div class="not-prose sm:flex flex-wrap">
          <%= for {post, index} <- Enum.with_index(Enum.take(@posts, 4)) do %>
            <div class="sm:w-1/2 mb-12">
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
                class="<%= "relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100" %>"
                >
                  <span class="font-medium text-black dark:text-white">Read more</span>
                </a>
              </div>
            </div>
          <% end %>
        </div>

        <!-- Older Posts Link -->
        <div class="flex justify-end mt-8">
          <a
            href="/blog"
            class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100"
          >
            <span class="font-medium text-black dark:text-white">Older posts →</span>
          </a>
        </div>
      </div>
    </div>
    """
  end
end
