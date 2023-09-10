# Scheduler

An easy-to-use **task scheduler** for [Pharo](https://www.pharo.org) that can run arbitrary blocks

[![Unit Tests](https://github.com/pharo-contributions/Scheduler/workflows/Build/badge.svg?branch=master)](https://github.com/pharo-contributions/Scheduler/actions?query=workflow%3ABuild)
[![Coverage Status](https://codecov.io/github/pharo-contributions/Scheduler/coverage.svg?branch=master)](https://codecov.io/gh/pharo-contributions/Scheduler/branch/master)

[![Pharo 7](https://img.shields.io/badge/Pharo-7.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 8](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 9](https://img.shields.io/badge/Pharo-9.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)


## Quick start

```Smalltalk
Metacello new 
    repository: 'github://pharo-contributions/Scheduler/src';
    baseline: 'Scheduler';
    load
```

[![Pharo Scheduler](https://img.youtube.com/vi/NOr32YgdujI/0.jpg)](https://www.youtube.com/watch?v=NOr32YgdujI)

## Overview

An easy-to-use task scheduler that can run arbitrary blocks:

Every so often (e.g. every hour starting now)

- Daily at a given time
- Periodically starting at a given time (e.g. every other hour starting a noon)
- Per a provide schedule (e.g. using Schedule instance you can run tasks every Monday and Friday)
- A one time task at some point in the future

For ease of use tasks can be blocks passed to the scheduler (or any object that understands #value).

### Example 1

```Smalltalk
"Start a new task scheduler and keep it around"
scheduler := TaskScheduler new.

scheduler start.
```

### Example 2

```Smalltalk
"Let's save the image every hour"
scheduler
    do: [Smalltalk snapshot: true andQuit: false]
    every: 60 minutes.
```

### Example 3

```Smalltalk
"Let's run a backup at 2am every day"
scheduler
    do: ["backup code here"]
    at: '2am'
```

### Example 4

```Smalltalk
"Let's perform a bank transfer every other hour starting at 1pm"
scheduler
    do: ["swiss bank account transfer code"]
    at: '1pm'
    every: 2 hours.
```

### Example 5

```Smalltalk
"Let's do a one time email reminder"
scheduler
    doOnce: ["email reminder to go on honeymoon"]
    at: '2005-1-15T8:00'
```

### Example 6

```Smalltalk
"Let's do a one time email reminder"
"You can delete tasks by sending #delete to them"
(scheduler taskAt: 1) delete
```

### Example 7

```Smalltalk
"Stop the scheduler from running -- but don't delete its tasks"
scheduler stop.
```
Read the provided tests for more examples.
