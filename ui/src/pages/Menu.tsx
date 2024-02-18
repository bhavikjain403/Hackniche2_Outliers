import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
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
import { AlertTriangle, Lightbulb, Star } from 'lucide-react';
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
import axios from 'axios';
import { NODEJS_ENDPOINT } from '../api/endpoints';
import { toast } from 'sonner';

function Menu() {
  const [menu, setMenu] = useState([]);
  const [refetch, setRefetch] = useState(0);

  useEffect(() => {
    const id = localStorage.getItem('id');
    axios
      .get(NODEJS_ENDPOINT + 'menu/getMenuByTruck' + '?id=' + id)
      .then((data) => {
        // const fetchedOrders = data.data.data.map((item, index) => ({
        //   ...item,
        //   id: item._id,
        // }));
        // console.log(new Date(fetchedOrders[0].placedTime).toLocaleTimeString());
        console.log(data.data.data);
        setMenu(data.data.data);
      });
    console.log('refetch done');
  }, [refetch]);

  const items = menu;
  const [isEditing, setIsEditing] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  function toggleEditMode(item) {
    if (item != null) {
      setEditingItem(item);
      setIsEditing(true);
    } else {
      setEditingItem(null);
      setIsEditing(false);
      setTimeout(() => {
        setRefetch((state) => state + 1);
      }, 1000);
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
            <TabsTrigger value="scan">Scan menu</TabsTrigger>
          </TabsList>
          {isEditing ? (
            <EditItem item={editingItem} exitEditingMode={toggleEditMode} />
          ) : (
            <ViewMenu
              setRefetch={setRefetch}
              items={items}
              enterEditingMode={toggleEditMode}
            />
          )}
          <AddItem
            prefilledItem={null}
            isInEditMode={false}
            setRefetch={setRefetch}
            exitEditingMode={() => null}
          />
          <ScanMenu setRefetch={setRefetch} />
        </Tabs>
      </div>
    </div>
  );
}

function ScanMenu({ setRefetch }) {
  const [thumbnail, setThumbnail] = useState([]);
  const [ocrItems, setOcrItems] = useState([]);

  useEffect(() => {
    console.log(ocrItems, 'ocr items in useeffect');
    if (ocrItems.length > 0) {
      axios
        .post(NODEJS_ENDPOINT + 'menu/bulkadditem', ocrItems)
        .then((data) => {
          console.log(data);
          toast('Menu items added', {
            description: 'Menu items were added succesfully!',
            action: {
              label: 'Close',
              onClick: () => null,
            },
          });
          setRefetch((state) => state + 1);
          setTabValue('view');
        });
    }
  }, [ocrItems]);
  return (
    <TabsContent value="scan">
      <Card>
        <CardHeader>
          <CardTitle>Scan menu</CardTitle>
          <CardDescription>Upload image of menu card</CardDescription>
        </CardHeader>
        <CardContent>
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
        </CardContent>
        <CardFooter className="flex justify-center px-6">
          <Button
            className="flex-1"
            onClick={() => {
              console.log(thumbnail[0].file);
              const formdata = new FormData();
              formdata.append(
                'image',
                thumbnail[0].file,
                thumbnail[0].file.name
              );
              formdata.append('isTable', 'true');

              const requestOptions = {
                method: 'POST',
                body: formdata,
                redirect: 'follow',
              };

              const truckId = localStorage.getItem('id');
              toast('Retrieving Menu', {
                description:
                  'The menu items are being retrieved by our OCR systems...',
                action: {
                  label: 'Close',
                  onClick: () => null,
                },
              });
              fetch(
                'https://6b0c-2402-3a80-42b0-6132-5813-1500-3e17-6e4d.ngrok-free.app/admin/menuextract',
                requestOptions
              )
                .then((response) => response.text())
                .then((result) => {
                  const finalResult = JSON.parse(result).map((item) => ({
                    name: item.dish,
                    price: parseInt(item.price.split(' ')[1]),
                    complete: false,
                    truckId: truckId,
                  }));
                  console.log(finalResult);
                  setOcrItems(finalResult);
                  toast('Menu Items retrieved', {
                    description: 'Menu item were retrieved successfully!',
                    action: {
                      label: 'Close',
                      onClick: () => null,
                    },
                  });
                })
                .catch((error) => console.error(error));
            }}
          >
            Submit
          </Button>
        </CardFooter>
      </Card>
    </TabsContent>
  );
}

function EditItem({ item, exitEditingMode }) {
  return (
    <AddItem
      exitEditingMode={exitEditingMode}
      prefilledItem={item}
      isInEditMode={true}
    />
  );
}

function ViewMenu({ setRefetch, items, enterEditingMode }) {
  return (
    <TabsContent value="view">
      <Card className="border-0">
        <CardContent className="px-1 py-0 min-h-[70vh]">
          <ScrollArea className=" py-2 h-full">
            <div className="w-full grid grid-cols-4 gap-5 px-4">
              {items.map((item, index) => {
                console.log(item.complete);
                return (
                  <Card
                    key={index}
                    className="rounded-3xl overflow-hidden drop-shadow-lg pb-2"
                  >
                    <CardContent className="flex items-center flex-col p-0">
                      {item.complete === false && (
                        <AlertTriangle
                          size={50}
                          className="absolute drop-shadow-lg top-4 right-4 stroke-amber-300 rounded-md  animate-pulse"
                        />
                      )}
                      <img
                        src={item.img}
                        className="mt-2 w-[95%] rounded-2xl object-cover aspect-square"
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
                          onClick={() => enterEditingMode(item)}
                        >
                          Edit
                        </Button>
                        <Button
                          onClick={() => {
                            axios
                              .get(
                                NODEJS_ENDPOINT +
                                  'menu/deleteitem?id=' +
                                  item._id
                              )
                              .then((data) => {
                                console.log(data);
                                toast('Menu item deleted', {
                                  description:
                                    'Menu item was deleted successfully!',
                                  action: {
                                    label: 'Close',
                                    onClick: () => null,
                                  },
                                });
                                setRefetch((state) => state + 1);
                              });
                          }}
                          className="flex-1"
                        >
                          Delete
                        </Button>
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

function AddItem({ setRefetch, exitEditingMode, prefilledItem, isInEditMode }) {
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
        truckId: localStorage.getItem('id'),
        cuisine,
        img: url,
        name,
        price: parseInt(amount),
        quantity: parseInt(quantity),
        veg: parseInt(category),
        customization,
        description,
        complete: true,
      };
      console.log(result);

      if (isInEditMode) {
        axios
          .post(NODEJS_ENDPOINT + 'menu/updateitem', {
            ...result,
            _id: prefilledItem._id,
          })
          .then((data) => {
            console.log(data);
            toast('Item was updated', {
              description: 'Item was succesfully updated!',
              action: {
                label: 'Close',
                onClick: () => null,
              },
            });
          });
      } else {
        axios.post(NODEJS_ENDPOINT + 'menu/additem', result).then((data) => {
          console.log(data);
          toast('Item was added', {
            description: 'Item was succesfully added to menu!',
            action: {
              label: 'Close',
              onClick: () => null,
            },
          });
        });
      }
      console.log('item was edited');
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
                {customizations.length > 0 &&
                  customizations?.map((item, index) => {
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
              className="flex-1"
              onClick={(e) => {
                e.preventDefault();
                prepareDataForApiRequest();
                exitEditingMode();
                setRefetch((state) => state + 1);
              }}
            >
              Submit
            </Button>
            <Button
              onClick={() => {
                exitEditingMode();
              }}
              className="flex-1"
              variant={'secondary'}
            >
              Close
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
