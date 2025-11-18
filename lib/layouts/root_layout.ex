defmodule PrWebsite.RootLayout do
  use Tableau.Layout
  import PrWebsite

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>

    <html lang="en" class="h-full">
      <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <title>
          <%= [@page[:title], "Pranav Ram"]
              |> Enum.filter(& &1)
              |> Enum.intersperse("|")
              |> Enum.join(" ") %>
        </title>

        <link rel="stylesheet" href="/css/site.css" />
        <link rel="icon" type="image/x-icon" href="/favicon.ico" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16.png" />
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <script src="/js/site.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>

        <!-- Dark mode detection script -->
        <script>
          // Apply dark mode on initial load based on system preference
          if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.documentElement.classList.add('dark');
          }
        </script>
      </head>

      <body class="dark:bg-slate-900 dark:text-white bg-white text-black h-full">
        <div class="px-4 md:px-0 md:max-w-2xl lg:max-w-3xl xl:max-w-5xl mx-auto min-h-full flex flex-col">
          <!-- Header -->
          <header class="flex justify-between items-center max-w-full w-full py-8 gap-x-12 md:gap-x-0">
            <a href="/" class="text-3xl font-medium no-underline flex-1 m-0 not-prose md:my-4 text-black dark:text-white">
              pranav/ram
            </a>

            <!-- Desktop Navigation -->
            <nav class="sm:flex items-center gap-4 hidden flex-1 justify-end">
            <a
            href="/blog"
            class="relative no-underline font-medium text-black dark:text-white before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100"
            >
            Blog
            </a>
            <a
            href="/tags"
            class="relative no-underline font-medium text-black dark:text-white before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100"
            >
            Tags
            </a>
              <a
                href="/about"
                class="relative no-underline font-medium text-black dark:text-white before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100"
              >
                About
              </a>
            </nav>
          </header>

          <!-- Main Content -->
          <main class="flex-1 prose dark:prose-invert lg:prose-xl prose-h1:mb-0 lg:prose-h1:mb-0 prose-h3:mb-0 lg:prose-h3:mb-0 prose-p:my-2 lg:prose-p:my-2 max-w-none">
            <%= render @inner_content %>
          </main>

          <!-- Footer -->
          <footer class="mt-16">
            <!-- Social Icons -->
            <div class="flex justify-center gap-4 mb-4">
              <a href="https://github.com/PranavRam" target="_blank" rel="noopener noreferrer" class="no-underline">
                <img
                  src="/images/github.webp"
                  alt="GitHub"
                  class="w-10 h-10 sm:w-12 sm:h-12 dark:invert"
                  loading="lazy"
                />
              </a>
              <a href="https://twitter.com/PranavRam" target="_blank" rel="noopener noreferrer" class="no-underline">
                <img
                  src="/images/twitter.webp"
                  alt="Twitter"
                  class="w-10 h-10 sm:w-12 sm:h-12 dark:invert"
                  loading="lazy"
                />
              </a>
              <a href="https://linkedin.com/in/pranavcnram" target="_blank" rel="noopener noreferrer" class="no-underline">
                <img
                  src="/images/linkedin.webp"
                  alt="LinkedIn"
                  class="w-10 h-10 sm:w-12 sm:h-12 dark:invert"
                  loading="lazy"
                />
              </a>
            </div>

            <!-- Footer Text -->
            <div class="py-4 flex flex-col justify-center items-center space-x-2 text-xs sm:text-sm text-gray-500 dark:text-gray-400 sm:flex-row not-prose">
              <div>Pranav Ram</div>
              <div class="hidden sm:block"> • </div>
              <div>© <%= DateTime.utc_now().year %></div>
              <div class="hidden sm:block"> • </div>
              <a href="/" class="no-underline text-gray-500 dark:text-gray-400 hover:text-black dark:hover:text-white">
                pranav/ram
              </a>
            </div>
          </footer>
        </div>

        <%= if Mix.env() == :dev do %>
          <%= Tableau.live_reload(assigns) %>
        <% end %>

        <script>
          // Convert Mermaid code blocks to divs for rendering
          document.querySelectorAll('pre code').forEach(function(el) {
            var content = el.textContent.trim();
            // Check if it's Mermaid syntax (starts with graph, sequence, etc.)
            if (content.match(/^(graph|sequenceDiagram|classDiagram|stateDiagram|erDiagram|journey|gantt|pie|flowchart|timeline|mindmap|block-beta|sankey|packet|architecture-beta)/)) {
              var pre = el.parentElement;
              var mermaidDiv = document.createElement('div');
              mermaidDiv.className = 'mermaid';
              mermaidDiv.textContent = content;
              pre.parentElement.replaceChild(mermaidDiv, pre);
            }
          });
          // Initialize and render Mermaid
          if (typeof mermaid !== 'undefined') {
            mermaid.initialize({ startOnLoad: false });
            mermaid.run();
          }
        </script>
      </body>
    </html>
    """
  end
end
