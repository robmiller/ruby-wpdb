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

## Installation

You can install ruby-wpdb via RubyGems:

	$ gem install ruby-wpdb

## Usage

[An in-depth tutorial for ruby-wpdb can be found
here](http://robm.me.uk/ruby/2013/10/24/ruby-wpdb-part-1.html).

But, in brief:

With ruby-wpdb you can do simple things like get the five most recent posts:

	WPDB::Post.reverse_order(:post_date).limit(5).all

Or more complicated things, like get the value of the custom field with
the key "image", but only for the first post whose title consists solely
of letters:

	WPDB::Post.first(:post_title => /^[a-z]+$/)
		.postmeta_dataset.first(:meta_key => 'image')
		.meta_value

Of course, you're not limited to retrieving records, you can create them
too:

	post = WPDB::Post.create(:post_title => 'Test', :post_content => 'Testing, testing, 123')

And ruby-wpdb knows all about the relationship between things in
WordPress — so if you want to create a new user, a post by that user,
and a tag for that post, you can do so by referring to the objects alone
without needing to know or care about what the actual relationships are
from the perspective of the database:

	author = WPDB::User.create(
		:user_login => 'fred',
		:user_email => 'fred@example.com'
	)

	term = WPDB::Term.create(:name => 'Fred Stuff')

	post = WPDB::Post.create(
		:post_title => 'Hello from Fred',
		:post_content => 'Hello, world',
		:author => author
	).add_term(term, 'tag')

## GravityForms

GravityForms is a great system for easily creating forms to capture
data. But its flexibility can make querying and exporting entries
difficult; querying even just a single form can often result in having
to write hairy SQL queries with many self-joins.

ruby-wpdb gives you an easier insight into your forms, allowing you to
treat them as though they were models of any other kind.

To make this a bit more concrete, imagine you had a contact form on your
site called "Contact Form". It has four fields: "Name", "Email",
"Message", and "Enquiry type".

ruby-wpdb allows you to do things like get the latest five entries to
have selected "quote" as their enquiry type:

	WPDB::GravityForms.ContactForm.where(:enquiry_type => 'quote').reverse_order(:date_created).limit(5).all

Or display the messages that have been sent since the start of 2013:

	WPDB::GravityForms.ContactForm.where(:date_created >= Date.new(2013, 1, 1)).each do |entry|
		puts "#{entry.enquiry_type} enquiry from #{entry.name} <#{entry.email}>\n"
		puts entry.message
		puts "---"
	end

Note that you get access to all the fields of the GravityForm as though
they were first-class members of an actual model, allowing you to use
their values when filtering and ordering.

## Console

ruby-wpdb comes with an interactive REPL console, so you can explore
a WordPress install without actually having to write any scripts.

Fire it up with:

	$ ruby-wpdb console

And you can then call:

	> init('mysql2://user:password@hostname/db_name')

To connect to your database.

If you find yourself connecting regularly to the same database, you can
tell ruby-wpdb where to find a config file:

	$ ruby-wpdb console --config-file wp-config.php

Which will remove the need to call `init` manually.

Once you're in the console, you cna do anything you'd be able to do with
ruby-wpdb normally. So to list all posts with the title 'Hello World',
you could call:

	> Post.where(post_title: "Hello World").all
