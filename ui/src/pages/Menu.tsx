import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { ScrollArea } from '@/components/ui/scroll-area';
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Dropzone, FileMosaic } from '@dropzone-ui/react';
import { Separator } from '@/components/ui/separator';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { cuisines } from '@/lib/MenuCuisines';
import { Star } from 'lucide-react';
import { LegacyRef, SyntheticEvent, useEffect, useRef, useState } from 'react';
import {
  getStorage,
  uploadBytesResumable,
  getDownloadURL,
  ref,
} from 'firebase/storage';
import { generateHex } from '@/lib/utils';
import { uploadFileToFirebase } from '@/lib/firebase-upload-file';
import { app } from '@/lib/firebase';
import vegIcon from '../assets/veg-icon.png';
import nonVegIcon from '../assets/non-veg-icon.png';

function Menu() {
  const dummyMenuItem = {
    truckId: 0,
    cuisine: cuisines[0],
    img: 'https://firebasestorage.googleapis.com/v0/b/nomnom-7ef89.appspot.com/o/menu%2F2024161750166484c74a1fdcassata-semifreddo-15858-2.jpg?alt=media&token=b8b2683a-a631-472f-9604-a64e9271a449',
    name: 'Ice cream',
    price: 999,
    quantity: 20,
    veg: 0,
    customization: [
      { name: 'chocolate syrup', amount: 20 },
      { name: 'choco chips', amount: 10 },
    ],
    description: 'this is an ice creamy cream',
  };
  const items = [
    dummyMenuItem,
    dummyMenuItem,
    dummyMenuItem,
    dummyMenuItem,
    dummyMenuItem,
    dummyMenuItem,
  ];
  const [isEditing, setIsEditing] = useState(false);
  const [editingItem, setEditingItem] = useState(null);

  function toggleEditMode(item) {
    console.log(item);
    if (item != null) {
      setEditingItem(item);
      setIsEditing(true);
    } else {
      setEditingItem(null);
      setIsEditing(false);
    }
  }

  return (
    <div className="hidden flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Menu</h2>
        </div>
        <Tabs defaultValue="view" className="space-y-4">
          <TabsList>
            <TabsTrigger value="view">View menu</TabsTrigger>
            <TabsTrigger value="add">Add item</TabsTrigger>
          </TabsList>
          {isEditing ? (
            <EditItem item={editingItem} exitEditingMode={toggleEditMode} />
          ) : (
            <ViewMenu items={items} enterEditingMode={toggleEditMode} />
          )}
          <AddItem prefilledItem={null} isInEditMode={false} />
        </Tabs>
      </div>
    </div>
  );
}

function EditItem({ item, exitEditingMode }) {
  return <AddItem prefilledItem={item} isInEditMode={true} />;
}

function ViewMenu({ items, enterEditingMode }) {
  return (
    <TabsContent value="view">
      <Card>
        <CardContent className="px-1 py-0 min-h-[70vh]">
          <ScrollArea className=" py-2 h-full">
            <div className="w-full grid grid-cols-4 gap-5 px-4">
              {items.map((item, index) => {
                return (
                  <Card
                    key={index}
                    className="rounded-3xl overflow-hidden drop-shadow-lg pb-2"
                  >
                    <CardContent className="flex items-center flex-col p-0">
                      <img
                        src={item.img}
                        className="mt-2 w-[95%] rounded-2xl  object-cover"
                      />

                      <div className="flex flex-col w-full px-3 pb-2 font-semibold text-xl">
                        <div className="mt-1 w-full flex justify-between">
                          {item.name}
                        </div>
                        <div className="font-medium text-sm w-full flex justify-between">
                          {item.description}
                        </div>
                        <div className="w-full flex justify-between">
                          <p className="my-4">₹ {item.price}</p>
                          <p className="flex items-center space-x-2">
                            {item.veg === 2 ? (
                              <img src={nonVegIcon} className="h-5" />
                            ) : (
                              <img src={vegIcon} className="h-5" />
                            )}
                            {item.veg === 0 && (
                              <p className="text-green-700">Jain</p>
                            )}
                          </p>
                        </div>
                      </div>
                      <div className="flex w-full justify-between px-3 gap-2">
                        <Button
                          variant={'secondary'}
                          className="border-slate-300 border-2 flex-1"
                          /* TODO: add id here */
                          onClick={() => enterEditingMode(item)}
                        >
                          Edit
                        </Button>
                        <Button className="flex-1">Delete</Button>
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </ScrollArea>
        </CardContent>
      </Card>
    </TabsContent>
  );
}

type customization = {
  name: string;
  amount: number;
};

function AddItem({ prefilledItem, isInEditMode }) {
  const formRef = useRef();
  const fbApp = app;
  const storage = getStorage();

  const [thumbnail, setThumbnail] = useState(
    prefilledItem?.img
      ? [
          {
            id: 'fileId',
            type: 'image/jpeg',
            imageUrl: prefilledItem?.img,
            name: 'Thumbnail.jpg',
          },
        ]
      : []
  );
  const [customizations, setCustomizations] = useState<customization[]>(
    prefilledItem?.customization || []
  );

  const [categoryDropDown, setCategoryDropDown] = useState(
    prefilledItem?.veg != undefined ? String(prefilledItem?.veg) : undefined
  );
  const [cuisineDropdown, setCuisineDropdown] = useState(
    prefilledItem?.cuisine
  );

  async function prepareDataForApiRequest() {
    if (formRef.current) {
      const name = formRef.current[0].value;
      const description = formRef.current[1].value;
      const amount = formRef.current[2].value;
      const quantity = formRef.current[3].value;
      const category = categoryDropDown;
      const cuisine = cuisineDropdown;
      const customization = customizations;

      let url;
      if (isInEditMode) {
        url = thumbnail[0].imageUrl;
      } else {
        const imageFile: File = thumbnail[0];
        const uploadFileName = generateHex() + imageFile.name;
        const metadata = {
          name: imageFile.name,
          size: imageFile.size,
          contentType: imageFile.type,
        };

        const storageRef = ref(storage, 'menu/' + uploadFileName);
        const uploadTask = uploadBytesResumable(
          storageRef,
          imageFile.file,
          metadata
        );
        uploadFileToFirebase(uploadTask);
        await uploadTask;
        url = await getDownloadURL(uploadTask.snapshot.ref);
      }

      const result = {
        truckId: 0,
        cuisine,
        img: url,
        name,
        price: amount,
        quantity,
        veg: category,
        customization,
        description,
      };
      console.log(result);
    }
  }

  return (
    <TabsContent
      value={isInEditMode ? 'view' : 'add'}
      className="flex justify-center items-center"
    >
      <Card className="w-[750px]">
        <CardHeader>
          <CardTitle>Add Item</CardTitle>
          <CardDescription>Add a new item to the menu</CardDescription>
        </CardHeader>
        <CardContent>
          <form ref={formRef} className="flex flex-col space-y-4">
            <div className="flex gap-4">
              <div className="flex-1 flex flex-col space-y-4">
                <Input
                  placeholder="Name"
                  name="name"
                  defaultValue={prefilledItem?.name || ''}
                />
                <Input
                  placeholder="Description"
                  name="description"
                  defaultValue={prefilledItem?.description}
                />
                <Input
                  placeholder="Price"
                  name="price"
                  type="number"
                  defaultValue={prefilledItem?.price}
                />
                <Input
                  placeholder="Quantity"
                  name="quantity"
                  type="number"
                  defaultValue={prefilledItem?.quantity}
                />
                <div className="gap-3 flex items-center justify-start">
                  <Label>Category</Label>
                  <Select
                    value={categoryDropDown}
                    onValueChange={(e) => setCategoryDropDown(e)}
                  >
                    <SelectTrigger className="w-[180px]">
                      <SelectValue placeholder="Select a category" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        <SelectItem value="0">Jain</SelectItem>
                        <SelectItem value="1">Veg</SelectItem>
                        <SelectItem value="2">Non Veg</SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
                <div className="gap-6 flex items-center justify-start">
                  <Label>Cuisine</Label>
                  <Select
                    value={cuisineDropdown}
                    onValueChange={(e) => setCuisineDropdown(e)}
                  >
                    <SelectTrigger className="w-[180px]">
                      <SelectValue placeholder="Select a Cuisine" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        {cuisines.map((item, index) => {
                          return (
                            <SelectItem key={index} value={item}>
                              {item}
                            </SelectItem>
                          );
                        })}
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="flex-1 -mt-8">
                <Label htmlFor="picture">Picture</Label>
                <Dropzone
                  onChange={(file) => {
                    console.log(file);
                    setThumbnail(file);
                  }}
                  value={thumbnail}
                  accept="image/png, image/jpeg, image/webp"
                  maxFiles={1}
                >
                  {thumbnail.map((file) => {
                    console.log(file);
                    return (
                      <FileMosaic
                        preview
                        key={file.id}
                        {...file}
                        onDelete={() => setThumbnail([])}
                        info
                      />
                    );
                  })}
                </Dropzone>
              </div>
            </div>
            <div className="flex flex-col space-y-2">
              <Label>Customization</Label>
              <Button
                type="button"
                className="w-fit"
                onClick={() =>
                  setCustomizations((state) => [
                    ...state,
                    { name: '', amount: 0 },
                  ])
                }
              >
                Add
              </Button>
              <div className="space-y-4 flex flex-col">
                {customizations?.map((item, index) => {
                  return (
                    <CustomizationPill
                      customization={item}
                      setCustomization={setCustomizations}
                      index={index}
                      key={index}
                    />
                  );
                })}
              </div>
            </div>
            <Button
              onClick={(e) => {
                e.preventDefault();
                prepareDataForApiRequest();
              }}
            >
              Submit
            </Button>
          </form>
        </CardContent>
      </Card>
    </TabsContent>
  );
}

function CustomizationPill({ customization, setCustomization, index }) {
  return (
    <div className="flex gap-2">
      <Input
        value={customization.name}
        placeholder="Name"
        onChange={(e) => {
          setCustomization((state) => [
            ...state.slice(0, index),
            { name: e.target.value, amount: state[index].amount },
            ...state.slice(index + 1),
          ]);
        }}
      />
      <Input
        value={customization.amount}
        placeholder="Amount"
        type="number"
        onChange={(e) => {
          setCustomization((state) => [
            ...state.slice(0, index),
            { name: state[index].name, amount: e.target.value },
            ...state.slice(index + 1),
          ]);
        }}
      />
      <Button
        onClick={(e) => {
          e.preventDefault();
          setCustomization((state) => [
            ...state.slice(0, index),
            ...state.slice(index + 1),
          ]);
        }}
      >
        Remove
      </Button>
    </div>
  );
}

export default Menu;
