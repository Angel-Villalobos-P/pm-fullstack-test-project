import React from 'react'
import { render, fireEvent, cleanup, screen } from '@testing-library/react'
import App from '../../app/javascript/packs/graph.jsx'

// Mock data for tests
const DUMMY_SNAPSHOT = {
  nodes: [ { id: 'Harry' }, { id: 'Sally' }, { id: 'Alice' } ],
  links: [
    { source: 'Harry', target: 'Sally', topics: 'Magic' },
    { source: 'Harry', target: 'Alice', topics: 'Potions' },
  ],
}

afterEach( cleanup )

it( 'Renders the App component with mock data', () => {
  const { getByText } = render( <App snapshot={ DUMMY_SNAPSHOT } /> )
  // Verify that the nodes are rendered
  expect( getByText( 'Harry' ) ).toBeInTheDocument()
  expect( getByText( 'Sally' ) ).toBeInTheDocument()
  expect( getByText( 'Alice' ) ).toBeInTheDocument()

  // Verify that the initial help text is displayed
  expect( getByText( /Hover your cursor over a connection line/i ) ).toBeInTheDocument()
} )

it( 'Updates the inspector when hovering over a link', () => {
  const { getByText, container } = render( <App snapshot={ DUMMY_SNAPSHOT } /> )

  // Simulate hovering over the Harry-Alice link
  const linkHarryAlice = container.querySelector( '[id="Harry,Alice"]' )
  fireEvent.mouseOver( linkHarryAlice )

  // Verify that the inspector displays the correct information

  // Select all <strong> and <em> elements within the <span>
  const strongElements = container.querySelectorAll( 'p > span > strong' )
  const emElement = container.querySelector( 'p > span > em' )

  // Verify that the content of the <strong> and <em> elements is as expected
  expect( strongElements[ 0 ].textContent ).toBe( 'Harry' )
  expect( strongElements[ 1 ].textContent ).toBe( 'Alice' )
  expect( emElement.textContent ).toBe( 'Potions' )
  expect( container.textContent.includes( 'chatted about' ) ).toBe( true )
} )

describe( 'Graph', () => {
  test( 'renders nodes correctly', () => {
    render( <App snapshot={ DUMMY_SNAPSHOT } /> )

    // Verify that the nodes are rendered correctly
    const nodeHarry = screen.getByText( 'Harry' )
    const nodeSally = screen.getByText( 'Sally' )
    const nodeAlice = screen.getByText( 'Alice' )

    expect( nodeHarry ).toBeInTheDocument()
    expect( nodeSally ).toBeInTheDocument()
    expect( nodeAlice ).toBeInTheDocument()
  } )
} )