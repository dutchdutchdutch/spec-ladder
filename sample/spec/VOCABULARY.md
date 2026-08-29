# Vocabulary

One canonical term per concept. Specs, plans, code, tests, and UI copy may not
use a rejected alias. A concept missing from this file is a question, not an
invitation to invent.

| Term | Definition | Rejected aliases |
|---|---|---|
| `Athlete` | A person following a Program | user, member, client, trainee |
| `Coach` | A person who authors Programs for Athletes | trainer, instructor, admin |
| `Program` | An ordered collection of Workouts assigned to an Athlete | plan, protocol, regimen |
| `Workout` | A single scheduled or completed training unit within a Program | session, activity, entry |
| `Exercise` | A named movement performed within a Workout | movement, drill |
| `Set` | One logged unit of an Exercise (reps × load or duration) | round, rep-group |
| `Intake` | The onboarding flow capturing an Athlete's goals, history, and consent | onboarding form, signup, questionnaire |
| `Feedback` | An Athlete's subjective report on a completed Workout (effort, notes) | review, rating, comment, survey |
| `Consent` | The Athlete's recorded agreement to data processing terms | agreement, acceptance, opt-in |

Note on "results": an Athlete's results ARE their logged `Set`s. There is no
separate Result entity — do not introduce one.

Promotion rule: a term used by more than one slice lives here. A slice must not
redefine a root term with a different meaning.
