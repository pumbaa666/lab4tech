[What is a Definition of Done (DoD)](https://www.scrum.org/resources/blog/getting-started-definition-done-dod)
===

- **A short, measurable checklist** – try and have things on your DoD that can be measured.
- **No further work required** from the Developers to ship your product to production. Any additional work means that you were not Done. Ideally, you have a fully automated process for delivering software.


[Why is "Done" so important?](https://www.scrum.org/resources/blog/walking-through-definition-done)
---

Well, incomplete work has a nasty habit of mounting up. The tyranny of work which is nearly done, but not really done, can put a team in servitude to **technical debt**.
Eventually the expense of fixing things, of repaying the debt, may exceed the value to be had from the next product increment.

Good examples
---

- Increment Passes SonarCube checks with no Critical errors.
- Increment’s Code Coverage stays the same or gets higher.
- Acceptance Tests for Increment are Automated.

[Undone](https://www.scrum.org/resources/blog/definition-done-should-include-definition-undone)
---

Most, robust websites have the ability to rollback, but actually, it is much harder to do with complex transactional systems.
If we ever want to break the "we can't release yet" cycle we have to start thinking about undone. How do we pull this back? Can we automate that?


[CI/CD - Continuous Integration / Continuous Delivery](https://www.scrum.org/resources/blog/definition-done-should-include-definition-undone)
---
In the beginning, there was Continuous Integration (CI).
Integration with others was normally a nightmare fraught with blame, fingers being pointed and problems. Then automated testing and then....
But there was a flaw – We delivered our code, even tested it, but then moving into production was a nightmare and there was a cost. 
Continuous Delivery was the response to this. It basically applied the ideas of CI on a much grander scale.
This whole CI/CD/DCA would be documented in a simple artifact, the Definition of Done (DoD). The DoD guides the team as they plan, do and deliver work. 

This is where we can put the non-fonctional development, like optimisation or refactoring. The infamous _nice-to-have_.
The developpers are accounted to express their concerns about potential futur problems and the necessity to correct them soon enough.