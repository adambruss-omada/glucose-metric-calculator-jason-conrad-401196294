import React, { useEffect, useState } from 'react';

const Dashboard = () => {
  const [metrics, setMetrics] = useState({
    averageWeek: null,
    averageMonth: null,
    timeAboveRangeWeek: null,
    timeAboveRangeMonth: null,
    timeBelowRangeWeek: null,
    timeBelowRangeMonth: null
  });

  useEffect(() => {
    const fetchMetrics = async () => {
      try {
        const response = await fetch('/home');
        const data = await response.json();
        setMetrics(data);
      } catch (error) {
        console.error('Error fetching metrics:', error);
      }
    };

    fetchMetrics();
  }, []);

  return (
    <div>
      <h1>Glucose Metrics Dashboard</h1>
      <div>
        <h2>Average Glucose (mg/dL)</h2>
        <p>Last 7 days: {metrics.averageWeek}</p>
        <p>Last month: {metrics.averageMonth}</p>
      </div>
      <div>
        <h2>Time Above Range (%)</h2>
        <p>Last week: {metrics.timeAboveRangeWeek}%</p>
        <p>Last month: {metrics.timeAboveRangeMonth}%</p>
      </div>
      <div>
        <h2>Time Below Range (%)</h2>
        <p>Last week: {metrics.timeBelowRangeWeek}%</p>
        <p>Last month: {metrics.timeBelowRangeMonth}%</p>
      </div>
    </div>
  );
};

export default Dashboard; 