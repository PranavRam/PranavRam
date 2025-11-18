defmodule Mix.Tasks.PrWebsite.Gen.Tags do
  use Mix.Task

  @shortdoc "Generate tags index and tag pages"
  @moduledoc @shortdoc

  @doc false
  def run(_) do
    base_path = Application.get_env(:tableau, :config)[:base_path] || ""
    posts_dir = "_posts"
    pages_dir = "_pages/tags"

    File.mkdir_p!(pages_dir)

    # Read and parse all posts
    posts = for file <- Path.wildcard("#{posts_dir}/*.md") do
      content = File.read!(file)
      [frontmatter, body] = String.split(content, "\n---\n", parts: 2)
      data = YamlElixir.read_from_string!(frontmatter)
      
      {:ok, date} = Date.from_iso8601(data["date"])
      date = DateTime.new!(date, ~T[00:00:00], "Etc/UTC")
      
      slug = data["title"]
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(" ", "-")
      |> String.replace(~r/-+/, "-")
      |> String.trim("-")
      
      %{
        title: data["title"],
        date: date,
        permalink: "#{base_path}/posts/#{slug}/",
        tags: data["tags"] || [],
        summary: data["summary"],
        body: body
      }
    end

    # Group posts by tag and sort
    tag_map = Enum.reduce(posts, %{}, fn post, acc ->
      Enum.reduce(post.tags, acc, fn tag, acc ->
        Map.update(acc, tag, [post], &[post | &1])
      end)
    end)
    
    tag_map = Map.new(tag_map, fn {tag, posts} ->
      {tag, Enum.sort_by(posts, & &1.date, &DateTime.compare(&1, &2) == :gt)}
    end)

    all_tags = Map.keys(tag_map) |> Enum.sort()

    # Generate tags index
    index_content = """
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
#{Enum.map_join(all_tags, "\n", fn tag ->
  count = length(tag_map[tag])
  """
  <a href="#{base_path}/tags/#{tag}/" class="block p-4 bg-gray-100 dark:bg-gray-800 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
    <span class="text-lg font-medium">##{tag}</span>
    <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">(#{count})</span>
  </a>
"""
end)}
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
"""

    File.write!("#{pages_dir}/index.md", index_content)

    # Generate individual tag pages
    for {tag, tag_posts} <- tag_map do
      tag_path = "#{pages_dir}/#{tag}.md"
      tag_dir = Path.dirname(tag_path)
      
      if tag_dir != pages_dir do
        File.mkdir_p!(tag_dir)
      end

      posts_content = if length(tag_posts) > 0 do
        """
<div class="not-prose sm:flex flex-wrap">
#{Enum.map_join(Enum.with_index(tag_posts), "\n", fn {post, index} ->
  margin_class = if rem(index, 2) == 0, do: "sm:mr-6", else: "sm:ml-6"
  summary = post.summary || String.slice(post.body, 0..150) <> "..."
  """
<div class="sm:w-1/2 mb-12">
<div class="#{margin_class}">
<div class="text-sm text-gray-500 dark:text-gray-400 mb-2">
Published #{Calendar.strftime(post.date, "%B %d, %Y")}
</div>
<a href="#{post.permalink}" class="text-2xl font-bold text-gray-800 dark:text-gray-200 hover:text-black dark:hover:text-white no-underline block mb-2">
#{post.title}
</a>
<p class="text-lg text-gray-600 dark:text-gray-400 mb-4">
#{summary}
</p>
<a href="#{post.permalink}" class="relative no-underline w-fit before:content-[''] before:absolute before:block before:w-full before:h-0.5 before:bottom-0 before:left-0 before:bg-black dark:before:bg-white before:scale-x-0 before:transition-transform before:duration-300 hover:before:scale-x-100">
<span class="font-medium text-black dark:text-white">Read more</span>
</a>
</div>
</div>
"""
end)}
</div>
"""
      else
        "No posts found for this tag."
      end

      tag_content = """
---
layout: PrWebsite.RootLayout
title: "##{tag}"
permalink: "/tags/#{tag}/"
---

<div class="flex justify-between items-center mb-8">
  <h1>##{tag}</h1>
  <input type="search" id="post-search" placeholder="Search posts..." class="w-64 px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400">
</div>

<div id="posts-list">
#{posts_content}
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('post-search');
  const postsList = document.getElementById('posts-list');
  const postCards = postsList.querySelectorAll('.sm\\\\:w-1\\\\\\/2');

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
"""

      File.write!(tag_path, tag_content)
    end

    Mix.shell().info("Successfully generated tags pages!")
  end
end
