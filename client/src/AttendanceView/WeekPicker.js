import React from 'react'
import PropTypes from 'prop-types'
import { Button } from 'antd'
import { LeftOutlined, RightOutlined } from '@ant-design/icons'

export function WeekPicker({ dateSelected, handleDateChange }) {
  return (
    <div>
      <Button onClick={() => handleDateChange(dateSelected.weekday(-7))}>
        <LeftOutlined />
      </Button>
      <Button
        className="mx-2"
        style={{
          color: '#1b82ab',
          borderColor: '#1b82ab'
        }}
      >
        {dateSelected.weekday(0).format('MMM D') +
          ' - ' +
          dateSelected.weekday(6).format('MMM D, YYYY')}
      </Button>
      <Button onClick={() => handleDateChange(dateSelected.weekday(7))}>
        <RightOutlined />
      </Button>
    </div>
  )
}

WeekPicker.propTypes = {
  dateSelected: PropTypes.number,
  handleDateChange: PropTypes.func
}
