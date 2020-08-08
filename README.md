# What is this?

A way to patch files in an official build of Firefox, rather than
rebuilding it yourself.

This can, of course, COMPLETELY BREAK YOUR FIREFOX INSTALLATION. Use at
your own risk. BACK UP YOUR PROFILE.

Most of the resources in a Firefox build are in JAR files called
`omni.ja`. If you want to change one of them, you need to re-zip that
jar in a specific way. This is a tool to do that.

# How does it work?

You copy only the files you want to edit to an overlay dir, and edit
them there. `foo.xhtml` from `firefox/omni.ja` goes directly in
`overlay/foo.xhtml`, and `bar.html` from `firefox/browser/omni.ja` goes
in `overlay/browser/bar.xhtml`.

Once you have made modifications, you repack the jars, replacing the
original versions of those files.

# And I do this by...?

Run `make`. `omni.ja` and `browser/omni.ja` will be extracted into
`firefox`, unzipped, overwritten with the contents of `overlay` and
`overlay/browser` respectively, and rezipped into `patched`.

This won't do anything useful if you do not have any files in `overlay`
yet; it will just copy the jars without any modification.

To actually destructively modify your installation with the files in
`patched`, run `make install DEST=/path/to/your/firefox`. Unless there
is a running `firefox` process, this will wipe your cache and back up
the official-build jars to `*.orig` before copying the modified jars in.

# Okay, but how do I do something useful with that?

You can just drop files in `overlay` and hack recklessly without
worrying about anything in this section, but here's what I do:

1.  Create a branch for pristine upstream files. I call this `upstream`.

2.  Extract the files that you want to modify to `overlay`.

3.  Commit them, noting which version they were imported from.

4.  Create another branch off of that and commit/make/install your
    modifications.

5.  When a new release of Firefox happens, re-import your base files to
    your `upstream` branch, and make a commit like "Update to 79.0".
    Then go back to your hack branch and do `git merge upstream`. Use
    your favorite merge tool to resolve conflicts, if any.

An example of this is in the `urlbar-emacs-nav` branch, which is why I
went down this particular rabbit hole in the first place. It was
bothering me that much.

# Is this even legal?

Well, nobody said it was a good idea.

If you publish your modifications, comply with the terms of the MPL and
put a copy of it in any branch containing modified or unmodified Mozilla
source code; those files are copyrighted and licensed.

# Can I change anything I want?

No.

# Why not?

You cannot currently modify .js files. This is because their hashes are
checked against ones in the JAR manifest, not unlike a Content Security
Policy. The entire manifest is signed, so you cannot record a different
hash for any file without invalidating the signature.

If you are reading this in the future, said protection may have been
extended to XUL/XHTML and other files (or at least inline scripts within
them), which means this is pretty much useless. Sorry! If I become aware
that this is imminent I'll try to add a notice of some sort.

I don't think that's a bad thing, honestly. The number of people who
will ever read this or even be interested in something like it is
vanishingly small, and the number of people who are at risk of being
hurt by malware that modifies their installation of Firefox is
increasingly large. Their safety is more important than our comfort.

# Are you... having a hard time dealing with quarantine?

Yes, yes I am.
