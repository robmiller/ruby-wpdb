# ruby-wpdb

WordPress is enormously popular; it powers some 20% of the web. Rare is
the web developer who doesn't come into contact with it, even those who
develop primarily in other languages. It's user-friendly, server
specification-friendly, and ubiquitous.

But what if you need to interact with WordPress from the outside? It
might be a cron-job, it might be a little command-line tool; you might
want to export or import some content, or you might want to clean some
things up. You don't have to do that in... *PHP*, do you?

If you'd like to do it in Ruby instead, then this library might help
with some of the boilerplate.

It's a wrapper for the WordPress database, using
[Sequel](http://sequel.rubyforge.org/), that gives you access to the
WordPress database and all its content via a nice ORM.

So, you can do simple things like get the five most recent posts:

	WPDB::Post.reverse_order(:post_date).limit(5).all

Or more complicated things, like get the value of a custom field that
has the key "image", but only for posts whose titles consist solely of
letters:

	WPDB::Post.where(:post_title => /^[a-z]+$/)
	  .postmeta.where(:meta_key => 'image')
	  .first.meta_value

## Usage

Datasets map exactly to database names without the prefix, and dataset
properties map exactly to column names. So, if you're familiar with
WordPress's database structure, ruby-wpdb should come fairly easy.

So if your WordPress database prefix is `wp_`, the default, then you'll
find the `wp_posts` table in the `posts` dataset, the `wp_users` table
in the `users` dataset, and so on.

Beyond that, you're limited with what you can do only by the
capabilities of Sequel; you can find out more in [their
README](http://sequel.rubyforge.org/rdoc/files/README_rdoc.html).
