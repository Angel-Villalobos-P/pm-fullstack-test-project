import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

// See react-d3-graph docs at https://danielcaldas.github.io/react-d3-graph/docs/index.html
import { Graph } from 'react-d3-graph'

const D3_GRAPH_CONFIG = {
  linkHighlightBehavior: true,
  width: 900,
  height: 600,
  node: {
    color: 'yellow',
    size: 120,
    highlightStrokeColor: 'blue',
  },
  link: {
    highlightColor: '#efefef',
  },
}

// custom prop types
const NodeShape = PropTypes.shape({
  id: PropTypes.string.isRequired,
})

const LinkShape = PropTypes.shape({
  source: PropTypes.string.isRequired,
  target: PropTypes.string.isRequired,
})

const SnapshotShape = PropTypes.shape({
  nodes: PropTypes.arrayOf(NodeShape).isRequired,
  links: PropTypes.arrayOf(LinkShape).isRequired,
})

// components
const Inspector = ({ source, target, topics }) => (
  <p>
    {source && target ? (
      <span>
        <strong>{source}</strong> and <strong>{target}</strong> chatted about{' '}
        <em>{topics}</em>
      </span>
    ) : (
      <em>Hover your cursor over a connection line</em>
    )}
  </p>
)
Inspector.propTypes = {
  source: PropTypes.string,
  target: PropTypes.string,
  topics: PropTypes.string,
}

const App = ( { snapshot } ) => {
  const [ currentSource, setCurrentSource ] = React.useState()
  const [ currentTarget, setCurrentTarget ] = React.useState()
  const [ currentTopics, setCurrentTopics ] = React.useState()

  const handleClickNode = _nodeId => { }

  const handleMouseOverNode = _nodeId => { }

  const handleMouseOutNode = _nodeId => { }

  const handleClickLink = (_source, _target) => { }

  const handleMouseOverLink = (source, target, topics) => {
    setCurrentSource(source)
    setCurrentTarget(target)
    findCurrentTopics(source, target)
  }

  const handleMouseOutLink = (_source, _target) => {
    setCurrentSource(undefined)
    setCurrentTarget(undefined)
    setCurrentTopics( undefined )
  }

  /**
   * Finds the current topics based on the source and target parameters.
   *
   * @param {string} source - The source parameter.
   * @param {string} target - The target parameter.
   */
  const findCurrentTopics = (source, target) => { 
    const link = snapshot.links.find(link => link.source === source && link.target === target)
    if (link && link.topics) {
      setCurrentTopics(link.topics)
    }
  }

  return (
    <div>
      <div>
        <Inspector
          source={currentSource}
          target={currentTarget}
          topics={currentTopics}
        />
      </div>
      <Graph
        id='graph'
        data={snapshot}
        config={D3_GRAPH_CONFIG}
        onClickNode={handleClickNode}
        onClickLink={handleClickLink}
        onMouseOverNode={handleMouseOverNode}
        onMouseOutNode={handleMouseOutNode}
        onMouseOverLink={handleMouseOverLink}
        onMouseOutLink={handleMouseOutLink}
      />
    </div>
  )
}
App.propTypes = {
  snapshot: SnapshotShape.isRequired,
}

const DUMMY_SNAPSHOT = {
  nodes: [ { id: 'Harry' }, { id: 'Sally' }, { id: 'Alice' } ],
  links: [
    { source: 'Harry', target: 'Sally' },
    { source: 'Harry', target: 'Alice' },
  ],
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App snapshot={SNAPSHOT_DATA || DUMMY_SNAPSHOT} />,
    document
      .getElementById('layout-wrapper')
      .appendChild(document.createElement('div'))
  )
} )

export default App