defmodule PrWebsite.PostLayout do
  use Tableau.Layout, layout: PrWebsite.RootLayout
  import PrWebsite

  def template(assigns) do
    base_path = PrWebsite.base_path(assigns.site[:config])
    ~H"""
    <article>
      <header>
        <h1><%= @page[:title] %></h1>
        <time datetime="<%= @page[:date] %>">
          <%= Calendar.strftime(@page[:date], "%B %d, %Y") %>
        </time>
        <%
          tags = @page[:tags] || []
        %>
        <div :if={tags != []} class="mt-2">
        <%= for tag <- tags do %>
        <a href="<%= base_path %>/tags/<%= tag %>/" class="inline-block bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 px-2 py-1 rounded-full text-sm mr-2 mb-2 no-underline hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
        #<%= tag %>
        </a>
        <% end %>
        </div>
      </header>

    <%= render @inner_content %>
    </article>
    """
  end
end
