# AmIPwned
A command line utility to validate a given password against a public database of
known data breaches.

By default, the program will prompt for a password to test, although you may
supply one on the command line if you are not concerned about leaking secrets
into the command history log. The password is never otherwise saved to
persistent storage.

Using a k-anonymity model, only a short prefix of the hashed password is shared
with the database. The database service never gains enough information about the
password to be able to exploit it later. More detail about how this data is
safeguarded is available at [Have I Been Pwned][hipb].

## Installation
Clone the repository to your local machine:
```bash
~$ git clone https://github.com/petejh/amipwned.git
```

## Usage
Print detailed documentation for command line options with:
```bash
~$ ruby amipwned.rb --help
```

## Contributing
AmIPwned provides a safe, welcoming space for collaboration. Everyone
contributing to our project—including the codebase, issue trackers, chat, email,
social media and the like—is expected to uphold our [Code of Conduct][coc].

Bug reports and pull requests are welcome on [GitHub][orig].

To contribute code, first [fork the project][fork] on GitHub and make a local
clone. Create a topic branch, make and commit your changes, and push this
branch back to GitHub. [Submit a pull request][pull] and ask to have your work
reviewed for inclusion in the main repository.

## License
This project is available as open source under the terms of the [MIT License][mit].

---
_This file is composed with [GitHub Flavored Markdown][gfm]._

[coc]:  https://github.com/petejh/amipwned/blob/master/CODE_OF_CONDUCT.md
[fork]: https://help.github.co://help.github.com/en/github/getting-started-with-github/fork-a-repo
[gfm]:  https://github.github.com/gfm/
[hipb]: https://haveibeenpwned.com/Privacy
[orig]: https://github.com/petejh/amipwned
[mit]:  https://github.com/petejh/amipwned/blob/master/LICENSE.txt
[pull]: https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork/
