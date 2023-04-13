# Effective Bootstrap

Everything your Ruby on Rails 5.1+ application needs to get working with [Twitter Bootstrap 4](https://getbootstrap.com/).

- Bootstrap4 component view helpers.
- SVG icons based on [Inline SVG](https://github.com/jamesmartin/inline_svg), with [Feather Icons](https://feathericons.com) and [FontAwesome](https://fontawesome.com) svg icons to replace the old glyphicons.
- An html-exact form builder that builds on top of Rails' new `form_with` with numerous custom form inputs.

## Getting Started

```ruby
gem 'effective_bootstrap'
```

Run the bundle command to install it:

```console
bundle install
```

Install the configuration file:

```console
rails generate effective_bootstrap:install
```

The generator will install an initializer which describes all configuration options.

Add the following to your `application.js`:

```ruby
//= require jquery3
//= require popper
//= require bootstrap
//= require effective_bootstrap

# The date picker form inputs use momentjs locales. To add a locale:
//= require moment/locale/es
//= require moment/locale/nl
```

And to your `application.scss`:

```sass
@import 'bootstrap'
@import 'effective_bootstrap'
```

## View Helpers

All these examples are in [haml](https://github.com/haml/haml).

### Collapse

https://getbootstrap.com/docs/4.0/components/collapse/

```haml
= collapse('Click to collapse/expand') do
  %p You have revealed me!
```

### Dropdown

https://getbootstrap.com/docs/4.0/components/dropdowns/

```haml
= dropdown do
  = dropdown_link_to 'Something', root_path
  = dropdown_divider
  = dropdown_link_to 'Another', root_path
```

Options include: `dropdown(variation: :dropup|:dropleft|:dropright, split: true|false, right: true|false, btn: 'btn-secondary')`

### ListGroup

https://getbootstrap.com/docs/4.0/components/list-group/

```haml
= list_group do
  = list_group_link_to 'Something', root_path
```

`list_group_link_to` will automatically insert the the `.active` class based on the request path.

### Navbar

https://getbootstrap.com/docs/4.0/components/navbar/

```haml
%nav.navbar.navbar-expand-lg.navbar-light.bg-light
  %a.navbar-brand{href: '/'} Home

  %button.navbar-toggler{type: 'button', data: {toggle: 'collapse', target: '#navContent', 'aria-controls': 'navContent', 'aria-label': 'Toggle navigation'}}
    %span.navbar-toggler-icon

  #navContent.collapse.navbar-collapse
    %ul.navbar-nav.mr-auto
      = nav_link_to 'About', '/about'
      = nav_link_to 'Contact', '/conact'

    %ul.navbar-nav
      - if current_user.present?
        = nav_dropdown('Account', right: true) do
          = nav_link_to 'Settings', user_settings_path

          - if can?(:access, :admin)
            = nav_divider
            = nav_link_to 'Site Admin', '/admin'

          = nav_divider
          = nav_link_to 'Sign Out', destroy_user_session_path, method: :delete
      - else
        = nav_link_to 'Sign In', new_user_session_path
```

`nav_link_to` will automatically insert the `.active` class based on the request path.

### Pagination

https://getbootstrap.com/docs/4.0/components/pagination/

Builds a pagination based on the given collection, current url and params[:page].

The collection must be an ActiveRecord relation.

```haml
= paginate(@posts, per_page: 10)
```

Add this to your model:

```ruby
scope :paginate, -> (page: nil, per_page:) {
  page = (page || 1).to_i
  offset = [(page - 1), 0].max * per_page

  limit(per_page).offset(offset)
}
```

Add this to your controller:

```ruby
def index
  @posts = Post.all.paginate(page: params[:page], per_page: 10)
end
```

Add this to your view:

```haml
%nav= paginate(@posts, per_page: 10)
```

or

```haml
%nav.d-flex.justify-content-center= paginate(@posts, per_page: 10)
```

### Tabs

https://getbootstrap.com/docs/4.0/components/navs/#tabs

```haml
= tabs do
  = tab 'Demographics' do
    %p Demographics tab

  = tab 'Orders' do
    %p Orders tab

  - if resource.logs.present?
    = tab 'Logs' do
      %p Logs tab
```

## Icon Helpers

Unfortunately, Bootstrap 4 dropped support for glyphicons, so we use a combination of [Inline SVG](https://github.com/jamesmartin/inline_svg), with [Feather Icons](https://feathericons.com) and [FontAwesome](https://fontawesome.com) .svg images (no webfonts) to get back this functionality, even better than it was before.

```haml
= icon('ok') # <svg class='eb-icon eb-icon-ok' ...>
```

```haml
= icon_to('ok', root_path) # <a href='/'><svg class='eb-icon eb-icon-ok' ...></a>
```

A full list of icons can be found here: [All effective_bootstrap icons](https://github.com/code-and-effect/effective_bootstrap/tree/master/app/assets/images/icons)

To overwrite or add an icon, just drop the `.svg` file into your application's `app/assets/images/icons/` directory.

There are also a few helpers for commonly used icons, they all take the form of `x_icon_to(new_thing_path)`:

- `new_icon_to`
- `show_icon_to`
- `edit_icon_to`
- `destroy_icon_to`
- `settings_icon_to`
- `ok_icon_to`
- `approve_icon_to`
- `remove_icon_to`

## Form Builder

Rails 5.1 has introduced a new `form_with` syntax, and soft-deprecated `form_tag` and `form_for`.

This gem includes a [Bootstrap4 Forms](https://getbootstrap.com/docs/4.0/components/forms/) html-exact form builder built on top of `form_with`.

The goal of this form builder is to output beautiful forms while matching the rails form syntax -- you should be able to change an existing `form_with` form to `effective_form_with` with no other changes.

Of course, just the regular form inputs are boring, and this gem extends numerous jQuery/Javascript libraries to level up some inputs.

This is an opinionated Bootstrap4 form builder.

## effective_form_with

Matches the Rails `form_with` tag syntax, with all its `:model`, `:scope`, `:url`, `:method`, etc.

As well, you can specify `layout: :vertical`, `layout: :horizontal`, or `layout: :inline` as per the different Bootstrap form layouts.

```haml
= effective_form_with(model: @user, layout: :horizontal) do |f|
  = f.text_field :name
  = f.submit
```

The default is `layout: :vertical`.

If you would like each form and its fields to have unique ids, use `unique_ids: true`.

All standard form fields have been implemented as per [Rails 5.1 FormHelper](http://api.rubyonrails.org/v5.1/classes/ActionView/Helpers/FormHelper.html)

When working as a `remote: true` form, you can also pass `flash_success: true|false` and `flash_error: true|false` to control the flash behaviour. By default, the errors will be displayed, and the success will be hidden.

### Options

There are three sets of options hashes that you can pass into any form input:

- `wrapper: { class: 'something' }` are applied to the wrapping div tag.
- `input_html: { class: 'something' }` are applied to the input, select or textarea tag itself.
- `input_js: { key: value }` are passed to any custom form input will be used to initialize the Javascript library. For example:

```ruby
= effective_form_with(model: @user) do |f|
  = f.date_field :updated_at, input_js: { useCurrent: 'day', showTodayButton: true }
```

will result in the following call to the Javascript library:

```javascript
$('input').datetimepicker(useCurrent: 'day', showTodayButton: true);
```
Any options passed in this way will be used to initialize the underlying javascript libraries.

## Basic form inputs

The following form inputs are supported, but don't have any kind of custom JavaScript

```haml
= f.check_box
= f.email_field
= f.error_field
= f.number_field
= f.password_field
= f.static_field
= f.text_area
= f.text_field
= f.url_field
```

## Custom date_field, datetime_field, time_field

These custom form inputs are all based on the following awesome project:

Bootstrap 3 Datepicker (https://github.com/Eonasdan/bootstrap-datetimepicker)

```haml
= f.date_field :updated_at
= f.datetime_field :updated_at
= f.time_field :updated_at
```

### Options

The default options used to initialize this form input are as follows:

```ruby
am_pm: true, input_js: { showTodayButton: false, showClear: false, useCurrent: 'hour' }
```

For a full list of options, please refer to:

http://eonasdan.github.io/bootstrap-datetimepicker/Options/

### Set Date

Use the following JavaScript to set the date:

```javascript
$('#start_at').data('DateTimePicker').date('2016-05-08')
```

### Disabled Dates

Provide a String, Date, or Range to set the disabled dates.

```ruby
input_js: { disabledDates: '2020-01-01' }
input_js: { disabledDates: Time.zone.now }
input_js: { disabledDates: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month }
input_js: { disabledDates: [Time.zone.now, Time.zone.now + 1.day] }
```

### Linked Dates

By default, when two matching date inputs named `start_*` and `end_*` are present on the same form, they will become linked.

The end date selector will have its date <= start_date disabled.

To disable this behaviour, call with `date_linked: false`.

```ruby
= f.date_field :end_at, date_linked: false
```

### Events

The date picker library doesn't trigger a regular `change`. Instead you must watch for the `dp.change` event.

More info is available here:

http://eonasdan.github.io/bootstrap-datetimepicker/Events/

## Custom editor

A drop in ready rich text editor based on

https://quilljs.com/

To use the editor, you must make additional javascript and stylesheet includes:

In your application.js

```
//= require effective_bootstrap
//= require effective_bootstrap_editor
```

In your application.scss

```
@import 'effective_bootstrap';
@import 'effective_bootstrap_editor';
```

And then in any form, instead of a text area:

```
= f.editor :body
```

## Custom has_many

This custom form input was inspired by [cocoon](https://github.com/nathanvda/cocoon) but works with more magic.

This nested form builder allows has_many resources to be created, updated, destroyed and reordered.

Just add `has_many` and `accepts_nested_attributes_for` like normal and then use it in the form:

```ruby
class Author < ApplicationRecord
  has_many :books
  accepts_nested_attributes_for :books, allow_destroy: true
end
```

and

```haml
= effective_form_with(model: author) do |f|
  = f.text_field :name

  = f.has_many :books do |fb|
    = fb.text_field :title
    = fb.date_field :published_at
```

If `:books` can be destroyed, a hidden field `_destroy` will automatically be added to each set of fields and a Remove button will be displayed to remove the item.

If the `Book` model has an integer `position` attribute, a hidden field `position` will automatically be added to each set of fields and a Reorder button will be displayed to drag&drop reorder items.

If the has_many collection is blank?, `.build()` will be automatically called, unless `build: false` is passed.

Any errors on the has_many name will be displayed unless `errors: false` is passed.

You can customize this behaviour by passing the following:

```haml
= f.has_many :books, add: true, remove: true, reorder: true, build: true, errors: true do |fb|
  = fb.text_field :title
```

or add an html class:

```haml
= f.has_many :books, class: 'tight' do |fb|
  = fb.text_field :title
```

## Custom percent_field

This custom form input uses no 3rd party jQuery plugins.

It displays a percentage formatted value `100` or `12.500` but posts the "percentage as integer" value of `100000` or `12500` to the server.

It's like the price field, but 3 digits instead of 2.

```haml
= f.percent_field :percent
```

## Custom price_field

This custom form input uses no 3rd party jQuery plugins.

It displays a currency formatted value `100.00` but posts the "price as integer" value of `10000` to the server.

Think about this value as "the number of cents".

```haml
= f.price_field :price
```

This gem also includes a rails view helper `price_to_currency` that takes a value like `10000` and displays it as `$100.00`

## Custom select

This custom form input is based on the following awesome project:

Select2 (https://select2.github.io/)

### Usage

As a Rails Form Helper input:

```ruby
= f.select :category, 10.times.map { |x| "Category #{x}"}
= f.select :categories, 10.times.map { |x| "Category #{x}"}, multiple: true
= f.select :categories, 10.times.map { |x| "Category #{x}"}, tags: true
= f.select :categories, {'Active': [['Post A', 1], ['Post B', 2]], 'Past': [['Post C', 3], ['Post D', 4]]}, grouped: true
```

### Modes

The standard mode is a replacement for the default single select box.

Passing `multiple: true` will allow multiple selections to be made.

Passing `freeform: true` will allow a single selection and new ones to be created.

Passing `multiple: true, tags: true` will allow multiple selections to be made, and new value options to be created.  This will allow you to both select existing tags and create new tags in the same form control.

Passing `grouped: true` will enable optgroup support.  When in this mode, the collection should be a Hash of ActiveRecord Relations or Array of Arrays

```ruby
{'Active' => Post.active, 'Past' => Post.past}
{'Active' => [['Post A', 1], ['Post B', 2]], 'Past' => [['Post C', 3], ['Post D', 4]]}
```

Passing `polymorphic: true` will enable polymorphic support.  In this mode, an additional 2 hidden input fields are created alongside the select field.

So calling

```ruby
= f.input :primary_contact, User.all.to_a + Member.all.to_a, polymorphic: true
```

will internally translate the collection into:

```ruby
[['User 1', 'User_1'], ['User 2', 'User_2'], ['Member 100', 'Member_100']]
```

and instead of posting to the server with the parameter `:primary_contact`, it will instead post `{primary_contact_id: 2, primary_contact_type: 'User'}`.

Using both `polymorphic: true` and `grouped: true` is recommended.  In this case the expected collection is as follows:

```ruby
= f.input :primary_contact, {'Users': User.all, 'Members': Member.all}, polymorphic: true, grouped: true
```

### Options

The default options used to initialize this form input are as follows:

```ruby
{
  :theme => 'bootstrap',
  :minimumResultsForSearch => 6,
  :tokenSeparators => [',', ' '],
  :width => 'style',
  :placeholder => 'Please choose',
  :allowClear => !(options[:multiple])  # Only display the Clear 'x' on a single selection box
}
```

### Interesting Available Options

To limit the number of items that can be selected in a multiple select box:

```ruby
maximumSelectionLength: 2
```

To hide the search box entirely:

```ruby
minimumResultsForSearch: 'Infinity'
```

For a full list of options, please refer to: https://select2.github.io/options.html


The following `input_js: options` are not part of the standard select2 API, and are custom `effective_select` functionality only:

To add a css class to the select2 container or dropdown:

```ruby
containerClass: 'custom-container-class'
dropdownClass: 'custom-dropdown-class'
```

to display rich html for the option value:

```ruby
f.select :user, user_tag_collection(User.all), template: :html

def user_tag_collection(users)
  users.map do |user|
    [
      user.to_s,
      user.to_param,
      { 'data-html': content_tag(:span, user.to_s, class: 'user-choice') }
    ]
  end
end
```

### Additional

Call with `single_selected: true` to ensure only the first selected option tag will be `<option selected="selected">`.

This can be useful when displaying multiple options with an identical value.

### Clear value

It's a bit tricky to clear the selected value

```coffeescript
$('select').val('').trigger('change.select2')
```

### Working with dynamic options

The following information applies to `effective_select` only, and is not part of the standard select2 API.

To totally hide (instead of just grey out) any disabled options from the select2 dropdown, initialize the input with:

```ruby
= f.input :category, User.all, hide_disabled: true
```

If you want to dynamically add/remove options from the select field after page load, you must use the `select2:reinitialize` event:

```coffeescript
# When something on my page changes
$(document).on 'change', '.something', (event) ->
  $select = $(event.target).closest('form').find('select.i-want-to-change')  # Find the select2 input to be updated

  # Go through its options, and modify some of them.
  # Using the above 'hide_disabled true' functionality, the following code hides the options from being displayed,
  # but you could actually remove the options, add new ones, or update the values/texts. whatever.
  $select.find('option').each (index, option) ->
    $(option).prop('disabled', true) if index > 10

  # Whenever the underlying options change, you need to manually trigger the following event:
  $select.select2().trigger('select2:reinitialize')
```

### AJAX Support

Provide the `ajax_url: ` method to use AJAX remote data source.

In your form:

```ruby
= f.select :user_id, User.all, ajax_url: users_select2_ajax_index_path
```

In your `routes.rb`:

```ruby
resources :select2_ajax, only: [] do
  get :users, on: :collection
end
```

In your controller:

```ruby
class Select2AjaxController < ApplicationController
  def users
    # Collection
    collection = User.all

    # Search
    if (term = params[:term]).present?
      collection = collection.where('name ILIKE ?', "%#{term}%").or(collection.where('id::TEXT LIKE ?', "%#{term}%"))
    end

    # Paginate
    per_page = 20
    page = (params[:page] || 1).to_i
    last = (collection.reselect(:id).count.to_f / per_page).ceil
    more = page < last

    offset = [(page - 1), 0].max * per_page
    collection = collection.limit(per_page).offset(offset)

    # Results
    results = collection.map { |user| { id: user.to_param, text: user.to_s } }

    respond_to do |format|
      format.js do
        render json: { results: results, pagination: { more: more } }
      end
    end
  end

end
```

## Custom select_or_text_field

This custom form input is unique. It takes in two different field names, one of them a select, the other a text field.

It enforces an `XOR` between the two fields.

It's intended for selecting a `belongs_to` or using a freeform text field pattern.

This custom form input uses no 3rd party jQuery plugins.

```haml
= f.select_or_text_field :post_id, :post_text, Post.all
= f.select_or_text_field :post_id, :post_text, Post.all, hint: 'Both select and text field will see this hint'
= f.select_or_text_field :post_id, :post_text, Post.all, select: { hint: 'select only options' }, text: { hint: 'text field only options'}
```

The `f.object` should have two separate attributes, `post_id` and `post_text`.

The javascript form input will enforce XOR, but you can also apply your own validation to also have the same effect as `required: true`

```
class PostSummary < ApplicationRecord
  validate do
    unless (post_id.present? ^ post_text.present?) # xor
      self.errors.add(:post_id, 'please choose either post or post text')
      self.errors.add(:post_text, 'please choose either post or post text')
    end
  end
end
```

## Custom submit and save

The `f.submit` puts in a wrapper and a default save button, and does the whole icon spin when submit thing.

The `f.save` is purely a input submit button.

```haml
= f.submit
= f.submit 'Save 2'

= f.submit 'Save', left: true
= f.submit 'Save', center: true
= f.submit 'Save', right: true

= f.submit 'Save', border: false
= f.submit 'Save', center: true, border: false
= f.submit 'Save', left: true, border: false

= f.submit(border: false) do
  = f.save 'Save 1'
  = f.save 'Save 2'
```

## Table Builder

Use `effective_table_with(resource)` to intelligently output a table of attributes for a resource.

In your view:

```
= effective_table_with(user, only: [:first_name, :last_name])
```

will output the following html:

```
<table class='table table-striped table-hover>
  <tbody>
    <tr>
      <td>First Name</td>
      <td>Peter</td>
    </tr>
    <tr>
      <td>Last Name</td>
      <td>Pan</td>
    </tr>
  </tbody>
</table>
```

You can pass `only:` and `except:` to specify which attributes to display.

To override the content of just one row:

```
= effective_table_with(user) do |f|
  = f.content_for :first_name, label: 'Cool First Name' do
    %strong= f.object.first_name
```

will generate the html:

`<tr><td>Cool First Name</td><td><strong>Peter</strong></td></tr>`

### Work with existing forms

The table builder is intended to display based off your existing forms.

Any `effective_form_with` or `_fields` partial will work to define the attributes displayed and the order they are displayed.

A check_box will be rendered as a boolean, text areas use simple_format, f.show_if and f.hide_if logic work.

If you use `f.text_field :first_name, label: 'Cool First Name'` in your form, it will flow through to the table.

To render a table based off an existing `effective_form_with`:

```
= effective_table_with(user) do |f|
  = render('users/form', user: user)
```

or just the fields partial

```
= effective_table_with(user, only: [:first_name, :last_name]) do |f|
  = render('users/fields_demographics', f: f)
```

You can specify `only:` and `except:` and use `f.content_for` to override a row in all these use cases.

All values flow through to i18n and can be overriden, same as the form labels, in the locale .yml file.

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

[Feather icons](https://github.com/feathericons/feather#license) are licensed under the [MIT License](https://opensource.org/licenses/MIT).

[FontAwesome icons](https://fontawesome.com/license) are licensed under the [CC BY 4.0 License](https://creativecommons.org/licenses/by/4.0/) and require this attribution.

## Credits

The authors of this gem are not associated with any of the awesome projects used by this gem.

We are just extending these existing community projects for ease of use with Rails Form Helper and SimpleForm.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
