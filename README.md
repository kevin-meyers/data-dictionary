### Notice
I haven't had a lot of time to work on new features recently, but a couple months ago I decided I wanted to get away from keter and use docker/terraform ([terraform repo](https://github.com/kevin-meyers/data-scout-terraform)) to bring my code to production! The current code works perfectly with the docker-compose, so the image created is what I want (and pretty small!).

Unfortunately learning terraform has been hard going, and I haven't been able to get the image up yet. I have had a lot of fun with it, and I will keep hammering at it until its finally working, then I will come back to adding more features!

I also wasn't planning on taking this off private, so it's probably not the cleanist it should be!

# Data Scout

The purpose of Data Scout is to be a companion to usually undocumented, hard to understand, hard to extend, and even harder to discover databases!

## Pros and Cons of Using Haskell
Pros:
* More fun than other langauges - felt a lot more motivation to wake up and get going again!
* Very accessible community of experts - Using the FP chat, I could ask questions to the contributors and creators of libaries that I use daily!
* Type safety on everything including routes made it easy to drastically change the layout of the site. For example, I wanted to break down an entire branch of the domain and add their pieces to other route children. All I needed to do was modify the config/routes exactly how I wanted it to look, and the compiler told me all the locations of routes that I needed to change!
* The scaffolded site came with lots of best practices built in, I ramped up quickly by mimicking and extending them.

Cons:
* I had a good amount of trouble using outdated libraries. Including some that were recommended by the yesod website and book.
* Ran into some complex type errors, but luckily I got great support from the FP community.

### Current functionality
Company:
* (In payments branch): When signing up, you can choose to either create a new company, or join an existing one.
* Has many Teams, to help model the hierarchy of the real business
* Only the founding User can edit the company, but anyone can create a new Team

Teams:
* The teams are used to allow hierarchy, they are owned by one user, and that user can belong to another team.

Tables:
* Creating a table will make you the Owner, which gives you the ability to grant permissions, edit, and delete the table.
* Having Edit Permission gives you the ability to edit the Table description, and all the columns on it.
* Having View Permission (unsurprisingly) allows you to view the Table, including it showing up in the list of accessible Tables.

In Progress:
* Stripe Payments
* Bulk actions for table permissions, like "grant Edit access to my team, or View access to the whole company"
* I have 2 search systems in progress, one using postgresql raw sql search to find columns, the other using [bloodhound elasticsearch](https://github.com/bitemyapp/bloodhound)

Most interesting upcoming issue:
* Adding table skeletons by providing db connection information instead of doing each one manually.


### User stories

While I was working as a data scientist, and as I am sure many of you have experienced, I was given a problem to solve like "help reduce time to mitigate bugs."
Now the company I was working for had 10's to hundreds of tables per database, hundreds or thousands of databases, and each table could have 50+ columns!

Just from my example thats already up to 5 million different columns of data that could be used to solve our problem... But you can't just search "time spent in queue" or "columns that have to do with bugs".

In fact, the columns that could very well help you solve their problem could be named some nonsense like "score" or "ts-300WEST" etc.

How these problems are solved now is you would go ask your coworkers or manager: "Hey, do you know of any tables that deal with tracking bugs?" and they might connect you with someone who might know, and that person might connect you with someone else, and eventually you might either give up and make YOUR OWN "score" column or find it after weeks of emails.

Now here is my proposed solution, and of course my vision for Data Scout:

### Vision

A web app where you can upload metadata about the databases you have like: table name, column name, connections with other tables. And extend them with extra documentation like table description, column descriptions, examples, data types, and even owning team!

A team page will have a description of the team, contact information for questions or requests, possibly team members? and a list of the tables they own (that you can see).

Custom permission system: you can only view the tables that you have access to, can only edit tables that you have Edit permissions granted from an Owner, who can grant permissions and delete.

Searchable documentation: You can search the documentation to help you locate data to solve your problem! I.e. searching "bug time" or "time spent in queue" will surface tables and columns that have documentation that relates!

This combined with the custom permission system will give a powerful discovery combination where other teams can let you discover their tables in the Data Scout even if you dont have permission to use the data itself. So if you discover tables that you want to use, you can reach out to the team and request access!

### Existing solution and difference
The most similar existing solution I found was dataedo, with their ability to add documentation very similar to how I would like to. The main differentiating factor will be my novel combination of permission system and searchability of documentation. Also mine will be much more focused on usability by people searching for data to solve their problems like data and business analysts, data scientists, management, and software engineers. 

## Haskell Setup

1. If you haven't already, [install Stack](https://haskell-lang.org/get-started)
   - On POSIX systems, this is usually `curl -sSL https://get.haskellstack.org/ | sh`
2. Install the `yesod` command line tool: `stack install yesod-bin --install-ghc`
3. Build libraries: `stack build`

If you have trouble, refer to the [Yesod Quickstart guide](https://www.yesodweb.com/page/quickstart) for additional detail.

## Development

Start a development server with:

```
stack exec -- yesod devel
```

As your code changes, your site will be automatically recompiled and redeployed to localhost.

## Tests

```
stack test --flag data-dictionary:library-only --flag data-dictionary:dev
```

(Because `yesod devel` passes the `library-only` and `dev` flags, matching those flags means you don't need to recompile between tests and development, and it disables optimization to speed up your test compile times).

## Documentation

- Read the [Yesod Book](https://www.yesodweb.com/book) online for free
- Check [Stackage](http://stackage.org/) for documentation on the packages in your LTS Haskell version, or [search it using Hoogle](https://www.stackage.org/lts/hoogle?q=). Tip: Your LTS version is in your `stack.yaml` file.
- For local documentation, use:
  _ `stack haddock --open` to generate Haddock documentation for your dependencies, and open that documentation in a browser
  _ `stack hoogle <function, module or type signature>` to generate a Hoogle database and search for your query
- The [Yesod cookbook](https://github.com/yesodweb/yesod-cookbook) has sample code for various needs

## Getting Help

- Ask questions on [Stack Overflow, using the Yesod or Haskell tags](https://stackoverflow.com/questions/tagged/yesod+haskell)
- Ask the [Yesod Google Group](https://groups.google.com/forum/#!forum/yesodweb)
- There are several chatrooms you can ask for help:
  _ For IRC, try Freenode#yesod and Freenode#haskell
  _ [Functional Programming Slack](https://fpchat-invite.herokuapp.com/), in the #haskell, #haskell-beginners, or #yesod channels.
