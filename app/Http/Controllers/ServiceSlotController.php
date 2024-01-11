<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Service;
use App\Models\ServiceSlots;

class ServiceSlotController extends Controller
{
    public function list($service_id)
    {
        return view('service-slot.index', [
            'service_slots' => ServiceSlots::getServiceTimings($service_id),
            'service_id' => $service_id
        ]);
    }

    public function add($service_id)
    {
        return view('service-slot.create', [
            'weekdays' => getWeekDaysList(),
            'service_id' => $service_id
        ]);
    }

    public function store($service_id, Request $request)
    {
        $request->validate([
            'weekday_number' => 'required',
            'timing' => 'required',
        ], [
            'weekday_number.required' => 'Weekday is required',
            'timing.required' => 'Time is required'
        ]);

        $data = $request->all();
        $data['service_id'] = $service_id;

        ServiceSlots::create($data);

        return redirect(route('services.slots.list', $service_id))->withSuccess('Slot added successfully');
    }

    public function edit($service_id, $slot_id)
    {
        $slot = ServiceSlots::findOrFail($slot_id);

        return view('service-slot.edit', [
            'weekdays' => getWeekDaysList(),
            'service_id' => $service_id,
            'slot'  => $slot
        ]);
    }

    public function update(Request $request, $service_id, $slot_id)
    {
        $request->validate([
            'weekday_number' => 'required',
            'timing' => 'required',
        ],[
            'weekday_number.required' => 'Weekday is required',
            'timing.required' => 'Time is required'
        ]);

        $data = [
            'weekday_number' => $request->input('weekday_number'),
            'timing' => $request->input('timing')
        ];

        ServiceSlots::where('id', $slot_id)->update($data);

        return redirect(route('services.slots.list', $service_id))->withSuccess('Slot updated successfully');
    }

    public function delete($service_id, $slot_id)
    {
        $slot = ServiceSlots::findOrFail($slot_id);
        $slot->delete();

        return redirect(route('services.slots.list', $service_id))->withSuccess('Slot deleted successfully');
    }
}