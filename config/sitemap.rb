# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://longbourn.cl"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add longbourn_executive_path, :priority => 0.9, :changefreq => 'weekly'
  add longbourn_startup_path, :priority => 0.9, :changefreq => 'weekly'
  add longbourn_institute_path, :priority => 0.9, :changefreq => 'weekly'
  add ingles_en_sede_path, :priority => 0.8, :changefreq => 'weekly'
  add cursos_toefl_path, :priority => 0.9, :changefreq => 'weekly'
  add metodologia_teg_path, :priority => 0.9, :changefreq => 'weekly'
  add cursos_empresas_path, :priority => 0.9, :changefreq => 'weekly'
  add contactanos_path, :priority => 0.3, :changefreq => 'weekly'
  add contactar_agente_path, :priority => 0.3, :changefreq => 'weekly'
  add jobs_longbourn_path, :priority => 0.3, :changefreq => 'weekly'
end
