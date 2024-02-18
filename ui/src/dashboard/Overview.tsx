import { Bar, BarChart, ResponsiveContainer, XAxis, YAxis } from "recharts";

const data = [
  {
    name: "Mon",
    total: 3000,
  },
  {
    name: "Tue",
    total: 2000,
  },
  {
    name: "Wed",
    total: 3500,
  },
  {
    name: "Thurs",
    total: 3000,
  },
  {
    name: "Fri",
    total: 4000,
  },
  {
    name: "Sat",
    total: 6000,
  },
  {
    name: "Sun",
    total: 7000,
  },
];

export function Overview() {
  return (
    <ResponsiveContainer width="100%" height={350}>
      <BarChart data={data}>
        <XAxis
          dataKey="name"
          stroke="#888888"
          fontSize={12}
          tickLine={false}
          axisLine={false}
        />
        <YAxis
          stroke="#888888"
          fontSize={12}
          tickLine={false}
          axisLine={false}
          tickFormatter={(value) => `$${value}`}
        />
        <Bar
          dataKey="total"
          fill="currentColor"
          radius={[4, 4, 0, 0]}
          className="fill-primary"
        />
      </BarChart>
    </ResponsiveContainer>
  );
}
