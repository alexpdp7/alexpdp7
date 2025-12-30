# On LLMs

This document is mostly an attempt to sort my thoughts on LLMs.
My intention is to flesh it out over time.

I recently saw a survey about LLMs that had four options: they are great, they are hype, they are harmful, they are fake.
My thought was: it's all of the above.

## LLMs are awesome

I am absolutely amazed at LLMs.
By crunching an absurd amount of data, you get a magical box that can continue any dialogue, including dialogue that performs translations, writes code, and many others.
Although I suspect it's less technologically impressive, you can ask an LLM to draw a picture of anything and the LLM produces it!

The components of LLMs are also magical.
When machine learning became a trend, many talented people found ways to turn things into vectors, which is amazing.
With LLMs, this trend continues.
Word embeddings can represent language as vectors, and we can operate with those vectors with semantic results.
This is an absolute breakthrough, with many profound implications.

### LLMs seem great for accessibility

Although I will elaborate later on my skepticism about some LLM results, I think that there are already valid applications of LLMs.

Mostly, in accessibility.
LLMs are effective describing images and videos, can do text to speech and speech to text, and others.
Accessibility is a very important field and even if I have big objections to LLM use, I think LLMs are likely a net positive for accessibility.
Any criticism of LLM must take into consideration such applications, and if we want to avoid LLM use in these fields, we *must* provide equivalent alternatives.
(Some of my criticism below is ethical about LLM companies using content against their authors' wishes, but I think few authors would really object on not-for-profit accessibility usage of LLMs.)

## LLMs are harmful

### LLMs seem to require blatant disregard of intellectual property to be viable

Napster (1999) was not the first high-profile case of massive copyright infringement, but since then, we have frequently seen large companies try to punish individuals to protect their intellectual property.

With LLMs, courts have found out that companies training LLMs have used pirated material in a massive scale.

I can see how for most people this is hugely unfair.

Intellectual property is a complex topic, but morally it does not seem defensible to me that someone can be in trouble for pirating a TV show while a large company can try to make a lot of money through pirating massively.

(As I mentioned, if this is not done for profit, to me this whole problem disappears.)

I have mixed feelings with regard to copyright law, but ultimately I think that authors deserve to have rights over the use of their work.
For example, I think it is fair that a song composer might forbid an organization such as a political party from using their songs.
Art ultimately benefits us, and I think some degree of copyright protection helps incentivize creators.

Therefore, given that LLM companies have widely admitted to using copyrighted material without permission, for-profit LLM companies must demonstrate that they have the right to use materials for training, and authors should have an easy way to prevent their works from being used, and to receive fair compensation if they want.

My position does not hinge on how transformative the LLM output is.
It hinges on what authors want from their work; I am pretty certain that most authors nowadays are OK with other authors taking inspiration from their work (because they were also certainly inspired by other authors), but they are not OK with a large company reselling their work without compensation, or being used to replace authors with a machine.

For other areas, such as writing programs using LLMs, I have similar objections.

LLMs are effective as long as they have sufficient training material.
In my opinion, if you think the LLM would not be effective if all content from authors who would object to your specific use of an LLM was removed, then you should not use the LLM for that specific purpose.

If you are using an LLM to create an illustration instead of commissioning an illustration, I think you should not do it because I don't think the LLM would be effective if all authors who objected to this use could remove their work from the training set.

(As mentioned, I think very few authors would object to an LLM describing images to a blind person without making an obscene profit.)

## LLMs are hype

### LLMs might not be effective for writing code

Hillel Wayne's [What we know we don't know](https://www.hillelwayne.com/talks/ese/ddd/) says that there are very few programming practices that are provably effective in increasing programming productivity.

Apparently, the most effective practice is code review, and its effectiveness is small compared to getting proper sleep, not being stressed, and working the right amount of hours.

Many other practices, such as good variable naming, or static or dynamic typing, do not seem to have a big effect, although most of us believe that some specific practices make us much more productive.

Many people claim that LLMs make them wildly more productive, and I even believe many of them truly believe so.

However, whenever I pull the thread on such claims, I tend to find things that make me skeptic.

I do not rule out that LLMs may increase productivity *today* for *some* tasks.
But I suspect they might *also* decrease productivity sometimes.
This lack of certainty of their effectiveness for coding *combined* with the rest of the problems I see with the use of LLMs drive me towards rejecting the use of LLMs for code.
They might help, but they might also hinder us, and I think it's better to be conservative with regard to their use.

### LLMs cannot be good oracles

My understanding of LLMs is that they are good at producing "things that look like X".

If you ask them to create a picture of X, then they will produce something that looks like a picture of X.
This is likely what you want, so I think LLMs can be reasonably effective at this task.

If you ask them to answer X, then they will produce some text that looks like the answer to X.
However, something that reads like the answer to a question is likely *not* an answer to the question.

Although it is surprising that many times the LLM will produce a correct answer, I think ultimately LLMs are not a good way to answer questions because they do that accidentally.

## LLMs are harmful

Or rather, they point to serious problems.

I see many programmers using LLMs to review their code or brainstorm.

Although LLMs might be somewhat effective in those tasks, I am surprised because people do not rely on other people for this.

To me, this points to people not having other people to collaborate with, or preferring to collaborate with a piece of software rather than someone else.

Although this might not be unequivocally harmful, it worries me, and I think we should spend time and resources looking at this phenomenon.

Personally, I think we should offer ourselves to others more, probably in a tit-for-tat fashion.

## Other sources

* [The Future of Software Development is Software Developers](https://codemanship.wordpress.com/2025/11/25/the-future-of-software-development-is-software-developers/)
  > “But this time it’s different, Jason!”
  > [...]
  > And there’s another important distinction: in previous cycles, the technology worked reliably.
  > We really could produce working software faster with VB or with Microsoft Access.
