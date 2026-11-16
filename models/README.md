# Source models and future benchmark

**19 SMV files, grouped into 14 systems: the Tuesday counter plus 13 future candidates.**
Only the course counter has been implemented and measured. All other safety
properties and family parameters below are **proposals** requiring review.

Files are already collected locally, unchanged, with original comments and notices.
The source folders are untracked because redistribution permission is unconfirmed.
For a new copy, download each linked file and place it at the displayed path relative
to `models/`. Copy LeanSMV files from its `models/` folder as described in the root README.
There is no downloader script.

LeanSMV source commit: `2349edc2eddb9a4f479f98c23f3d257a72945472`.
Official NuSMV examples: <https://nusmv.fbk.eu/examples.html>, collected November 15,
2026; the page supplies no release identifier for individual examples. All files
below retain their original **SMV** format.

| System | Source files and destination paths | Safety property | Family parameter |
| --- | --- | --- | --- |
| course-counter **(Tuesday: proved)** | [leansmv/counter.smv](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/counter.smv) | x <= N (proved) | threshold N |
| traffic-light | [leansmv/traffic_light.smv](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/traffic_light.smv) | not both lights green | green phase durations |
| mutual-exclusion | [leansmv/mutex.smv](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/mutex.smv)<br>[nusmv/smv-dist/mutex.smv](https://nusmv.fbk.eu/examples/smv-dist/mutex.smv)<br>[nusmv/smv-dist/mutex1.smv](https://nusmv.fbk.eu/examples/smv-dist/mutex1.smv)<br>[nusmv/smv-dist/semaphore.smv](https://nusmv.fbk.eu/examples/smv-dist/semaphore.smv) | at most one critical process | process count |
| cellular-flow | [leansmv/cellular3.smv](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/cellular3.smv)<br>[leansmv/cellular_mc_2x2.smv](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/cellular_mc_2x2.smv) | each cell capacity respected and no conflicting ownership | topology size, colors, capacities |
| euclid-gcd | [leansmv/gcd.smv](https://github.com/ttj/leansmv/blob/2349edc2eddb9a4f479f98c23f3d257a72945472/models/gcd.smv) | gcd(a,b) equals initial gcd (requires ghost initial values) | initial operand bound |
| fifo-queue | [nusmv/queue/queue.smv](https://nusmv.fbk.eu/examples/queue/queue.smv) | implementation output agrees with abstract FIFO on valid reads | queue capacity and data width |
| priority-queue | [nusmv/p-queue/p-queue.smv](https://nusmv.fbk.eu/examples/p-queue/p-queue.smv) | dequeued value has maximal configured priority among stored elements | capacity and priority width |
| producer-consumer | [nusmv/prod-cons/prod-cons.smv](https://nusmv.fbk.eu/examples/prod-cons/prod-cons.smv) | no consumption from empty buffer or overwrite of occupied unread slot | buffer size, producer/consumer counts |
| synchronous-arbiter | [nusmv/smv-dist/syncarb5.smv](https://nusmv.fbk.eu/examples/smv-dist/syncarb5.smv)<br>[nusmv/smv-dist/syncarb10.smv](https://nusmv.fbk.eu/examples/smv-dist/syncarb10.smv) | at most one simultaneous grant | number of requesters |
| synchronous-bit-counter | [nusmv/smv-dist/counter.smv](https://nusmv.fbk.eu/examples/smv-dist/counter.smv) | next value equals (current + 1) mod 2^width | bit width |
| robot-controller | [nusmv/smv-dist/robot.smv](https://nusmv.fbk.eu/examples/smv-dist/robot.smv) | AG !error (no task deadline miss) | task count, periods, deadlines |
| bounded-retransmission | [nusmv/brp/brp.smv](https://nusmv.fbk.eu/examples/brp/brp.smv) | receiver never delivers incorrect or duplicated data | retransmission bound and message length |
| alternating-bit | [nusmv/abp/abp4.smv](https://nusmv.fbk.eu/examples/abp/abp4.smv) | delivered payload agrees with last accepted send | payload width |
| production-cell | [nusmv/production-cell/production-cell.smv](https://nusmv.fbk.eu/examples/production-cell/production-cell.smv) | no unsafe simultaneous actuator configuration | number of workpieces or timing bounds |

Keep these five companion READMEs beside their models: [p-queue/README](https://nusmv.fbk.eu/examples/p-queue/README), [prod-cons/README](https://nusmv.fbk.eu/examples/prod-cons/README), [brp/README](https://nusmv.fbk.eu/examples/brp/README), [abp/README](https://nusmv.fbk.eu/examples/abp/README), [production-cell/README](https://nusmv.fbk.eu/examples/production-cell/README).

Grouping notes: `cellular3` and `cellular_mc_2x2` are chain/grid and color variants
of one cellular-flow family. `syncarb5` and `syncarb10` are two sizes of one arbiter.
The exclusion and semaphore protocols are conservatively counted as one overlapping
family. FIFO, priority queue, and producer/consumer share a domain but have different
behaviors. Bounded retransmission and alternating-bit are different protocols.
The official page aliases its abp8/10/11 links to abp4, so only abp4 was collected.
Production-cell is a larger reserve candidate; feasibility needs review.

**The official `nusmv/smv-dist/counter.smv` is a three-bit counter with different
semantics. Tuesday always uses `leansmv/counter.smv`.** All six LeanSMV models
were present, including traffic_light, mutex, cellular3, and cellular_mc_2x2.

## MCMT: not yet collected

Prioritize small imperative programs and parameterized mutual exclusion in their
original formats. Do not create a model folder until actual inputs are obtained.
The old homepage was readable through web retrieval, but its Download/Experiments
links did not yield benchmark files. Local checks on November 15, 2026 reported:

| URL checked | Actual local result |
| --- | --- |
| http://users.mat.unimi.it/users/ghilardi/mcmt/ | HTTP 200, but the body was a network access-denied page |
| https://users.mat.unimi.it/users/ghilardi/mcmt/ | curl exit 60: HTTPS certificate validation failed |
| https://homes.di.unimi.it/~ghilardi/mcmt/home.html | curl exit 60: HTTPS certificate validation failed |
| http://homes.dsi.unimi.it/~ghilardi/mcmt/license.html | HTTP 200, but the body was a network access-denied page |
| http://homes.dsi.unimi.it/~ghilardi/mcmt/experiments.html | HTTP 200, but the body was a network access-denied page |
| https://homes.di.unimi.it/~ghilardi/mcmt/license.html | curl exit 60: HTTPS certificate validation failed |
| https://homes.di.unimi.it/~ghilardi/mcmt/experiments.html | curl exit 60: HTTPS certificate validation failed |

MCMT contributes **zero** systems to the count. Ask the professor for original
benchmark inputs or download them from an authorized accessible source, then
place them under `models/mcmt/` with their notices. No MCMT model result is claimed.
