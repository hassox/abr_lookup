# AbrLookup

A simple Gem to perform ABN and ACN lookups for Australian Businesses

## What you get

### Successful Lookup

<pre><code>
  lookup = AbrLookup::Lookup.new('my abn').lookup_abn!
  lookup.abn           # abn number
  lookup.current       # true if the abn is currently active
  lookup.lookup_number # The number that was given to query
  
  # Entity Information
  lookup.entity_status           # Active for active abns
  lookup.entity_type             # A code to indicate the type of entity
  lookup.entity_type_description
  lookup.effective_from          # The date the abn was registered
  lookup.effective_to            # Not usable if the abn is still active
  lookup.trading_name
  lookup.state_code              # The state the abn is registered in
  lookup.postcode
  
  # Business Registerer
  lookup.given_name 
  lookup.family_name
</code></pre>

### Failed Request

When a request fails, the lookup object implements an ActiveModel errors
object.

<pre><code>
  lookup = AbrLookup::Lookup.new('something bad').lookup_abn!
  lookup.errors.full_messages # Array of messages
</code></pre>

### Use as middleware

You can use AbrLookup as middleware in your Rack application to respond
to JSON requests at "/abn\_lookup" and takes a parameter of 'abn'
containig the number to search for

#### Example

/abn\_lookup?abn=12345677 #=> A JSON response

To setup the middleware

#### Rack

<pre><code>use AbrLookup::Server
run app
</code></pre>

#### Rails

<pre><code>Rails.configuration.middleware.insert AbrLookup::Server</code></pre>



## Configuration

There is only one configuration option at the moment that is valid.

guid - The guid that you get when you apply for access to the web
service from http://abr.business.gov.au/

By default, if there is a file config/abr.yml present, it will be loaded
and used as the configuration.

Customize the the configuration path with
<pre><code>AbrLookup.config_path = "my_path"</code></pre>

Configuration can also be set via a hash
<pre><code>AbrLookup.configuration = {'guid' => 'some
guid'}</code></pre>

## Requirements

In order to use this gem, you'll need to get an authorized guid from http://www.abr.business.gov.au/Webservices.aspx

This is unfortunately a bit of a manual process, but it's not too
painful.
