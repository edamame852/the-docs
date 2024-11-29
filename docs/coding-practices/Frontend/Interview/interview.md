---
title: Interview
layout: default
parent: Frontend 
grand_parent: Coding Practices
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# 1. Interview Questions (& ans)

## Describe React
- Popular opinion: Lib rather than framework (since not next.js)
- React lib using js/ts to create UI interfaces

## What's JSX
- Not directly coding in CSS, html..., We code with JSX
- JSX the template language for react = creating html dynamically = putting js into html
- Benefit of JSX: Has the feel of html but allow to code in js (best of both worlds)
- Downside of JSX: SKIPPED

## What's the virtual dom (Document Object Model)
- Fact: React doesn't interact with the REAL dom
- React -> virtual dom (a tool that react uses to check what changed) -> Real dom
- DOM = what you see on the browser
- virtual dom = to make efficient updates (by comparing the difference in real dom)

## Downside of virtual dom ?
1. Lower Performance: if computationally expensive since Everything NEEDS to go through virtual dom 

Signals: new tool, not react related can bypass virtual dom, not in component

## Controlled inputs/components vs uncontrolled

Inputs always has a value

- Controlled inputs = control the state
    - When state is involved, value from state used as input and onchange the value

- Uncontrolled inputs
    - No state, get value from inputs by useRef (get value from inputs)

## Common hooks in react ?
1. useEffect: to fetch data (Now: react Query (based on useEffect) is used more often)
    - useEffect concerns and handling:
        - risk conditions
        - abort controllers
        - loading states, error states
2. useMemo: for performance and to save unnecessary renders
3. useCallback: 
- while passing function to useEffect, use useCallback to avoid infinite call back
- or when passing function to component and don't want unnecessary rendering


4. useState:  A way to remember values
```js
funciton Counter() {
    const [count, setCount] = useState(0); // Default is 0 or in same cases: null
    return (
        <div>
            <p>You already clicked {count} times</p>
            <button onClick={()=>setCount(count+1)}>
                Click me bro
            </button>
        </div>
    )
} 
```

5. useRef: for connecting 3rd party lib function (i.e. MUI does useRef under the hood)

## How are props used?
pros high level: To pass data from 1 component to another 

```js
function Greetings(props){
    return <h1>Hello my, {props.name}</h1>
}

function App(){
    return (
        <div>
            <Greeting name='dude'>
            <Greeting name='boi'>
        </div>
    )
}
```

## How is useState and useRef different ?

useRef: you can store values in it (i.e. count), it's non-reactive = it's non-render-able
(Workaround: in a function, you can assign new value to ref and access in the next line)
useState: you can store values as well, and it's reactive = have to wait for re-render

## What's context and how it works?

Context: Making the component to access the state from top-level component and all child component has access to = **prop drilling**

## Pros and cons of prop drilling?
pros: Child components has access to parent component states
cons: Messy (too much embedded components, renaming = breaking the chain)

## Where do we use Context?
Context: for example, dark mode

# State management
